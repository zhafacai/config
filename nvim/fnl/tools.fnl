(import-macros {: gh-pkg! : nmap! : map! : set! : autocmd!} :macros)

(gh-pkg! :nvim-lua/plenary.nvim)

(gh-pkg! :rktjmp/paperplanes.nvim {:setup {}})

(gh-pkg! :NeogitOrg/neogit {:setup {}})
(nmap! :<leader>gg :<cmd>Neogit<CR>)

(gh-pkg! :esmuellert/codediff.nvim {:setup {}})
(nmap! :<leader>gd :<cmd>CodeDiff<CR>)

(gh-pkg! :MagicDuck/grug-far.nvim {:setup {}})
(nmap! :<leader>sf :<cmd>GrugFar<CR>)

(gh-pkg! :mikavilpas/yazi.nvim {:setup {}})
(nmap! :<a-e> :<cmd>Yazi<cr>)

(gh-pkg! :nvzone/volt)
(gh-pkg! :nvzone/floaterm
         {:setup {:terminals [{:name :Terminal}
                              {:name :Terminal}
                              {:name :Terminal}]}})

(map! [:n :t] :<a-i> :<CMD>FloatermToggle<CR> {:desc "Toggle floaterm"})

(set! g loaded_netrwPlugin 1)
(gh-pkg! :stevearc/oil.nvim
         {:setup {:keymaps {:q :actions.close
                            :gq :q
                            :gd {:callback (fn []
                                             (set vim.g.oil_detail
                                                  (not vim.g.oil_detail))
                                             (let [oil (require :oil)]
                                               (if vim.g.oil_detail
                                                   (oil.set_columns [:icon
                                                                     :permissions
                                                                     :size
                                                                     :mtime])
                                                   (oil.set_columns [:icon]))))
                                 :desc "Toggle file detail view"}}}})

(nmap! "-" :<CMD>Oil<CR> {:desc "Open parent directory"})

(gh-pkg! :stevearc/conform.nvim
         {:setup {:format_on_save {:timeout_ms 500 :lsp_format :fallback}
                  :formatters_by_ft {:lua [:stylua]
                                     :sh [:shfmt]
                                     :python [:black]
                                     :fennel [:fnlfmt]
                                     :nix [:nixfmt]
                                     :rust [:rustfmt]
                                     :fennel [:fnlfmt]}}})

(gh-pkg! :lambdalisue/vim-suda)

(gh-pkg! :benoror/gpg.nvim)
; (gh-pkg! :icarios-dev/privymd.nvim {:setup {}})
(gh-pkg! :olimorris/codecompanion.nvim
         {:setup {:interactions {:chat {:adapter :opencode}}}})
