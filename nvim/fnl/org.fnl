(import-macros {: gh-pkg! : nmap! : autocmd! : augroup!} :macros)

(let [od (vim.fn.expand "~/notes")]
  (gh-pkg! :zhafacai/denote.nvim
           {:setup {:filetype :org
                    :directory (.. od :/denote/)
                    :prompts [:title :keywords]
                    :integrations {:oil true}}
            :version :uiselect})
  (gh-pkg! :nvim-orgmode/orgmode
           {:setup {:org_agenda_files (.. od :/agenda/*)
                    :org_default_notes_file (.. od :/refile.org)
                    :org_startup_indented true
                    :hyperlinks {:sources [(: (require :denote.extensions.orgmode)
                                              :new {:files (.. od :/denote/)})]}
                    :mappings {:global {:org_agenda false}}}})
  (gh-pkg! :hamidi-dev/org-super-agenda.nvim
           {:setup {:org_files [(.. od :/refile.org)]}})
  (gh-pkg! :nvim-orgmode/telescope-orgmode.nvim)
  (gh-pkg! :nvim-orgmode/org-bullets.nvim {:setup {}}))

(nmap! :<leader>oa :<cmd>OrgSuperAgenda<CR>)
(nmap! :<leader>oA :<cmd>OrgSuperAgenda!<CR>)

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
