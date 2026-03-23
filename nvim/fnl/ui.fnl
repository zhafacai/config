(import-macros {: gh-pkg! : nmap!} :macros)

(gh-pkg! :b0o/incline.nvim {:setup {}})

(gh-pkg! :rachartier/tiny-inline-diagnostic.nvim {:setup {}})
(vim.diagnostic.config {:virtual_text false})
(vim.diagnostic.config {:float {:source true}
                        :severity_sort true
                        :signs {:severity {:min vim.diagnostic.severity.HINT}
                                :text {vim.diagnostic.severity.ERROR ""
                                       vim.diagnostic.severity.HINT ""
                                       vim.diagnostic.severity.INFO ""
                                       vim.diagnostic.severity.WARN ""}}
                        :underline {:severity {:min vim.diagnostic.severity.INFO}}
                        :update_in_insert true})

(gh-pkg! :OXY2DEV/helpview.nvim)

(gh-pkg! :OXY2DEV/markview.nvim)

(gh-pkg! :folke/which-key.nvim)

(gh-pkg! :kevinhwang91/nvim-bqf)

(gh-pkg! :Bekaboo/dropbar.nvim)

(gh-pkg! :nacro90/numb.nvim {:setup {}})

(gh-pkg! :lewis6991/satellite.nvim {:setup {}})

(gh-pkg! :aileot/emission.nvim {:setup {}})

(gh-pkg! :uga-rosa/ccc.nvim {:setup {}})

(gh-pkg! :catgoose/nvim-colorizer.lua {:setup {} :name :colorizer})

(gh-pkg! :kevinhwang91/nvim-hlslens {:setup {} :name :hlslens})
(let [hlslens "<Cmd>lua require('hlslens').start()<CR>"]
  (nmap! :n (.. "<Cmd>execute('normal! ' . v:count1 . 'n')<CR>" hlslens))
  (nmap! :N (.. "<Cmd>execute('normal! ' . v:count1 . 'N')<CR>" hlslens))
  (nmap! "*" (.. "*" hlslens))
  (nmap! "#" (.. "#" hlslens))
  (nmap! :g* (.. :g* hlslens))
  (nmap! "g#" (.. "g#" hlslens)))

(gh-pkg! :chrisgrieser/nvim-origami {:setup {} :name :origami})

(gh-pkg! :folke/todo-comments.nvim {:setup {}})
(let [todo (require :todo-comments)]
  (nmap! "]t" #(todo.jump_next) {:desc "Next Todo Comment"})
  (nmap! "[t" #(todo.jump_prev) {:desc "Previous Todo Comment"}))

(gh-pkg! :rebelot/kanagawa.nvim)
(vim.cmd "colorscheme kanagawa")
