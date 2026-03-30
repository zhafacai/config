(import-macros {: map! : nmap! : autocmd!} :macros)

(nmap! :<leader>r :<CMD>restart<CR> {:desc :restart})

;; Emacs keybinds
(map! [:c :i] :<C-a> :<Home> {:desc "Move to beginning of line"})
(map! [:c :i :n] :<C-e> :<End> {:desc "Move to end of line"})
(map! [:c :i] :<C-b> :<Left> {:desc "Move backward"})
(map! [:c :i] :<C-f> :<Right> {:desc "Move forward"})
(map! [:c] :<C-g> :<C-c> {:desc :quit})
(map! [:x :t] :<C-g> :<ESC> {:desc :quit})

(map! :v :J :5j)
(map! :v :K :5k)

(nmap! :j :gj)
(nmap! :k :gk)

(nmap! :<C-g> :<esc><cmd>noh<cr>)

(autocmd! :FileType [:help
                     :grug-far*
                     :qf
                     :lspinfo
                     :man
                     :query
                     :checkhealth
                     :Neogit*
                     :norg*
                     :org*
                     :markdown
                     :octo
                     :text]
          #(do
             (nmap! :q vim.cmd.q {:buffer true})
             (nmap! :gq :q {:buffer true})))

(autocmd! :LspAttach "*"
          #(do
             (nmap! :gd vim.lsp.buf.definition {:buffer true})))
