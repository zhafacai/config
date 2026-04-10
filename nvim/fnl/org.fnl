(import-macros {: gh-pkg! : nmap! : autocmd! : augroup!} :macros)

(let [od (vim.fn.expand "~/notes")
      fd #(.. od $1)]
  (gh-pkg! :zhafacai/denote.nvim
           {:setup {:filetype :org
                    :directory (fd :/denote/)
                    :prompts [:title :keywords]
                    :integrations {:oil true}}
            :version :uiselect})
  (gh-pkg! :nvim-orgmode/orgmode
           {:setup {:org_agenda_files [(fd :/agenda/*) (fd :/refile.org)]
                    :org_default_notes_file (fd :/refile.org)
                    :win_split_mode :float
                    :org_startup_indented true
                    :hyperlinks {:sources [(: (require :denote.extensions.orgmode)
                                              :new {:files (fd :/denote/)})]}
                    :mappings {:global {:org_agenda false}}}})
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

(autocmd! :FileType :org
          (fn [ev]
            (let [tom (require :telescope-orgmode)]
              (tom.setup {:adapter :snacks})
              (nmap! :<leader>sh tom.search_headings
                     {:desc "Org headlines" :buffer ev.buf})
              (nmap! :<leader>st tom.search_tags
                     {:desc "Org tags" :buffer ev.buf})
              (nmap! :<leader>sr tom.refile_heading
                     {:desc "Org refile" :buffer ev.buf})
              (nmap! :<leader>sl tom.insert_link
                     {:desc "Org insert link" :buffer ev.buf}))))
