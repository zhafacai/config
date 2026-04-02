(import-macros {: gh-pkg! : nmap!} :macros)

(gh-pkg! :nvim-mini/mini.starter {:setup {:evaluate_single true}})
(gh-pkg! :nvim-mini/mini.statusline {:setup {}})
(gh-pkg! :nvim-mini/mini.icons {:setup {}})
(gh-pkg! :nvim-mini/mini.diff {:setup {}})
(gh-pkg! :nvim-mini/mini.pick {:setup {}})
(gh-pkg! :nvim-mini/mini.operators
         {:setup {:replace {:prefix :R :reindent_linewise true}}})

(gh-pkg! :nvim-mini/mini.align {:setup {}})
(gh-pkg! :nvim-mini/mini.cursorword {:setup {}})
(gh-pkg! :nvim-mini/mini.indentscope {:setup {}})
(gh-pkg! :nvim-mini/mini.move {:setup {}})
(gh-pkg! :nvim-mini/mini.splitjoin {:setup {}})
(gh-pkg! :nvim-mini/mini.notify {:setup {}})
(gh-pkg! :nvim-mini/mini.bracketed {:setup {:treesitter {:suffix ""}}})
(gh-pkg! :nvim-mini/mini-git {:setup {} :name :mini.git})

(gh-pkg! :kylechui/nvim-surround)

; (gh-pkg! :nvim-mini/mini.pairs {:setup {}})
(gh-pkg! :windwp/nvim-autopairs {:setup {:disable_filetype [:fennel]}})

(nmap! :<leader><leader> "<cmd>Pick files<CR>")
(nmap! :<leader>f "<cmd>Pick grep_live<CR>")
(nmap! :<leader>hh "<cmd>Pick help<CR>")
