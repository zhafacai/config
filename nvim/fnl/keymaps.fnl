(import-macros {: map! : nmap! : autocmd!} :macros)

(nmap! :<leader>r :<CMD>restart<CR> :restart)

;; Emacs keybinds
(map! [:c :i] :<C-a> :<Home> "Move to beginning of line")
(map! [:c :i :n] :<C-e> :<End> "Move to end of line")
(map! [:c :i] :<C-b> :<Left> "Move backward")
(map! [:c :i] :<C-f> :<Right> "Move forward")
(map! [:c] :<C-g> :<C-c> :quit)
(map! [:x :t] :<C-g> :<ESC> :quit)
(nmap! :<a-x> ":" "Enter command mode")

(map! :v :J :5j "Move down 5 lines")
(map! :v :K :5k "Move up 5 lines")

(nmap! :j :gj "Move down (visual)")
(nmap! :k :gk "Move up (visual)")

(nmap! :<C-g> :<esc><cmd>noh<cr> "Clear search highlight")

(autocmd! :FileType [:mininotify-history]
          #(nmap! :q vim.cmd.bd {:buffer true :desc "Close buffer"}))

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
             (nmap! :q vim.cmd.q {:buffer true :desc "Close window"})
             (nmap! :gq :q {:buffer true :desc "Record macro"})))

(autocmd! :LspAttach "*"
          #(do
             (nmap! :gd vim.lsp.buf.definition
                    {:buffer true :desc "Go to definition"})))

(autocmd! :TextYankPost "*"
          #(vim.highlight.on_yank {:higroup :WildMenu :timeout 400}))
