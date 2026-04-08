(import-macros {: gh-pkg! : nmap! : autocmd!} :macros)

(gh-pkg! :nvim-mini/mini.statusline {:setup {}})
(gh-pkg! :nvim-mini/mini.icons {:setup {}})
(gh-pkg! :nvim-mini/mini.diff {:setup {}})
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

; (gh-pkg! :nvim-mini/mini.pick {:setup {}})
; (nmap! :<leader><leader> "<cmd>Pick files<CR>")
; (nmap! :<leader>f "<cmd>Pick grep_live<CR>")
; (nmap! :<leader>hh "<cmd>Pick help<CR>")
; (gh-pkg! :nvim-mini/mini.starter {:setup {:evaluate_single true}})
(gh-pkg! :nvim-mini/mini.sessions {:setup {}})

(let [keys [{:action ":lua Snacks.dashboard.pick('files')"
             :desc "Find File"
             :icon " "
             :key :<space><space>}
            {:action ":Neogit" :desc :Git :icon " " :key :n}
            {:action :<cmd>OrgSuperAgenda!<CR>
             :desc :Agenda
             :icon "󰠮 "
             :key :a}
            {:action "<cmd>Org capture<CR>"
             :desc :Capture
             :icon " "
             :key :c}
            {:action ":lua Snacks.dashboard.pick('live_grep')"
             :desc "Live Grep"
             :icon " "
             :key :f}
            {:action ":lua Snacks.dashboard.pick('oldfiles')"
             :desc "Recent Files"
             :icon " "
             :key :r}
            {:action ":lua Snacks.dashboard.pick('files', {cwd = '~/dots'})"
             :desc :Config
             :icon " "
             :key :C}
            {:desc "Restore Session"
             :icon " "
             :key :s
             :action ":lua MiniSessions.read()"}
            {:action ":qa" :desc :Quit :icon " " :key :q}]
      sections [; {:section :header}
                ; {:section :terminal
                ;  :cmd "figlet -f slant 'zfc' | lolcat -F 0.3 -t -p 100 -f"
                ;  :padding 1
                ;  ; :indent 30
                ;  :panel 2}
                {:icon " "
                 :indent 2
                 :padding 1
                 :section :keys
                 :title :Keymaps}
                {:icon " "
                 :indent 2
                 :padding 1
                 :section :recent_files
                 :title "Recent Files"}
                {:icon " "
                 :indent 2
                 :padding 1
                 :section :projects
                 :title :Projects}]]
  (gh-pkg! :folke/snacks.nvim
           {:setup {:bigfile {:enabled true}
                    ; :input {:enabled true}
                    :image {:enabled true}
                    :scratch {:enabled true}
                    :dashboard {:enabled true :preset {: keys} : sections}
                    :picker {:enabled true}}}))

(nmap! :<leader><leader> #(Snacks.picker.smart) "Smart picker")
(nmap! :<leader>f #(Snacks.picker.grep) :Grep)
(nmap! :<leader>hh #(Snacks.picker.help) :Help)
(nmap! :<leader>hr #(Snacks.picker.registers) :Registers)
(nmap! :<leader>ha #(Snacks.picker.autocmds) :Autocmds)
(nmap! :<leader>hc #(Snacks.picker.commands) :Commands)
(nmap! :<leader>hd #(Snacks.picker.diagnostics) :Diagnostics)
(nmap! :<leader>hl #(Snacks.picker.highlight) :Highlights)
(nmap! :<leader>hk #(Snacks.picker.keymaps) :Keymaps)
(nmap! :<leader>hm #(Snacks.picker.marks) :Marks)
(nmap! :<leader>ho #(Snacks.picker.colorschemes) :Colorschemes)
(nmap! :<leader>gb #(Snacks.gitbrowse) "Git browse")
(nmap! :<leader>ss #(Snacks.scratch) "Scratch buffer")
(nmap! :<leader>sS #(Snacks.scratch.select) "Select scratch")
(nmap! :<leader>sI #(Snacks.picker.icons) :Icons)

(autocmd! :User :SnacksDashboardOpened
          #(tset vim.b $1.buf :miniindentscope_disable true))
