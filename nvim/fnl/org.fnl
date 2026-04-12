(import-macros {: gh-pkg! : nmap! : autocmd! : augroup! : map!} :macros)

(let [od (vim.fn.expand "~/notes")
      fd #(.. od $1)]
  (gh-pkg! :zhafacai/denote.nvim
           {:setup {:filetype :org
                    :directory (fd :/denote/)
                    :prompts [:title :keywords]
                    :integrations {:oil true}}
            :version :uiselect})
  (gh-pkg! :nvim-orgmode/orgmode
           {:setup {:org_agenda_files [(fd :/agenda/*)
                                       ; (fd :/agenda/refile.org)
                                       ]
                    :mappings {:agenda {:org_agenda_schedule :s
                                        :org_agenda_deadline :d}
                               :org {:org_meta_return :<a-cr>}}
                    :org_hide_emphasis_markers true
                    :org_agenda_custom_commands {:a {:description :Agenda
                                                     :types [{:type :agenda}
                                                             {:match "+TODO=\"NEXT\""
                                                              :org_agenda_overriding_header :Tasks
                                                              :type :tags_todo}
                                                             {:match "+TODO=\"TODO\""
                                                              :org_agenda_overriding_header :Process
                                                              :type :tags_todo}
                                                             {:match "DEADLINE>=\"<+1d>\"&DEADLINE<\"<+2d>\"|SCHEDULED>=\"<+1d>\"&SCHEDULED<\"<+2d>\""
                                                              :org_agenda_overriding_header "Due Tomorrow"
                                                              :type :tags_todo}
                                                             {:match "DEADLINE<\"<today>\"&DEADLINE>\"<-7d>\"|SCHEDULED<\"<today>\"&SCHEDULED>\"<-7d>\""
                                                              :org_agenda_overriding_header :Overdue
                                                              :type :tags_todo}
                                                             {:match "DEADLINE<\"<-7d>\"|SCHEDULED<\"<-7d>\""
                                                              :org_agenda_overriding_header "Long Overdue"
                                                              :type :tags_todo}]}}
                    :org_capture_templates {:d {:description :Deadline
                                                :template "* TODO %?
DEADLINE: %T"}
                                            :s {:description :Schedule
                                                :template "* TODO %?
SCHEDULED: %T"}
                                            :t {:description :Todo
                                                :template "* TODO %?\n"}
                                            :n {:description :Next
                                                :template "* NEXT %?\n"}}
                    :org_agenda_start_on_weekday false
                    :org_log_into_drawer :LOGBOOK
                    :org_todo_keywords ["TODO(t)"
                                        "NEXT(n)"
                                        "|"
                                        "DONE(d)"
                                        "CNCL(c)"]
                    :org_default_notes_file (fd :/agenda/refile.org)
                    :win_split_mode [:float 0.88]
                    :org_startup_indented true
                    :ui {:agenda {:preview_window {:border :single}}}
                    :hyperlinks {:sources [(: (require :denote.extensions.orgmode)
                                              :new {:files (fd :/denote/)})]}}})
  ;; BUG:Buggy
  ;; (gh-pkg! :zhafacai/org-super-agenda.nvim
  ;;          {:setup {:org_files [(fd :/agenda/*) (fd :/refile.org)]}
  ;;           :version :fix/close-window-cleanly})
  (gh-pkg! :nvim-orgmode/telescope-orgmode.nvim)
  (gh-pkg! :nvim-orgmode/org-bullets.nvim {:setup {}}))

; (nmap! :<leader>oa :<cmd>OrgSuperAgenda<CR>)
; (nmap! :<leader>oA :<cmd>OrgSuperAgenda!<CR>)

(nmap! :<leader>nn :<cmd>Denote<CR> :Denote)
(nmap! :<leader>ns :<cmd>DenoteSearch<CR> :DenoteSearch)
(nmap! :<leader>nl :<cmd>DenoteInsertLink<CR> :DenoteInsertLink)
(nmap! :<leader>nb :<cmd>DenoteBacklinks<CR> :DenoteBacklinks)

(augroup! :OrgMaps ;;
          (autocmd! :FileType :org
                    #(let [tom (require :telescope-orgmode)]
                       (tom.setup {:adapter :snacks})
                       (map! :i :<S-CR>
                             #(let [orgmode (require :orgmode)]
                                (orgmode.action :org_mappings.meta_return))
                             {:buffer true :silent true})
                       (nmap! :<leader>sh tom.search_headings
                              {:desc "Org headlines" :buffer true})
                       (nmap! :<leader>st tom.search_tags
                              {:desc "Org tags" :buffer true})
                       (nmap! :<leader>sr tom.refile_heading
                              {:desc "Org refile" :buffer true})
                       (nmap! :<leader>sl tom.insert_link
                              {:desc "Org insert link" :buffer true}))))
