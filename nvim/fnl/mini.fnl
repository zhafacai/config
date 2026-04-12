(import-macros {: set! : gh-pkg! : nmap! : autocmd! : augroup!} :macros)

(gh-pkg! :nvim-mini/mini.statusline)
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
(gh-pkg! :windwp/nvim-autopairs {:setup {;; :disable_filetype [:fennel]
                                         }})

; (gh-pkg! :nvim-mini/mini.pick {:setup {}})
; (nmap! :<leader><leader> "<cmd>Pick files<CR>")
; (nmap! :<leader>f "<cmd>Pick grep_live<CR>")
; (nmap! :<leader>hh "<cmd>Pick help<CR>")
; (gh-pkg! :nvim-mini/mini.starter {:setup {:evaluate_single true}})
(gh-pkg! :nvim-mini/mini.sessions {:setup {}})
(nmap! :<leader>S :<cmd>mksession<CR>)

(let [keys [{:action ":lua Snacks.dashboard.pick('files')"
             :desc :File
             :icon " "
             :key :<space><space>}
            {:action ":lua Snacks.dashboard.pick('live_grep')"
             :desc :Grep
             :icon "󱡴 "
             :key :f}
            {:action ":lua Snacks.dashboard.pick('oldfiles')"
             :desc :Recent
             :icon " "
             :key :r}
            {:action ":lua Snacks.picker.help()"
             :desc :Help
             :icon "󰞋 "
             :key :h}
            {:action ":Neogit" :desc :Git :icon " " :key :g}
            {:action "<cmd>Org agenda<CR>" :desc :Agenda :icon "󱨋 " :key :a}
            ; {:action :<cmd>OrgSuperAgenda!<CR>
            ;  :desc :SuperAgenda
            ;  :icon "󰠮 "
            ;  :key :a}
            {:action ":Denote" :desc :Note :icon " " :key :n}
            {:action "<cmd>Org capture<CR>"
             :desc :Capture
             :icon "󰛨 "
             :key :c}
            {:action ":lua Snacks.dashboard.pick('files', {cwd = '~/dots'})"
             :desc :Config
             :icon " "
             :key :C}
            {:desc :Session
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
(nmap! :<leader>hn #(MiniNotify.show_history) :Notifications)
(nmap! :<leader>hr #(Snacks.picker.registers) :Registers)
(nmap! :<leader>ha #(Snacks.picker.autocmds) :Autocmds)
(nmap! :<leader>hc #(Snacks.picker.commands) :Commands)
(nmap! :<leader>hH #(Snacks.picker.command_history) :CommandHistory)
(nmap! :<leader>hd #(Snacks.picker.diagnostics) :Diagnostics)
(nmap! :<leader>hl #(Snacks.picker.highlights) :Highlights)
(nmap! :<leader>hk #(Snacks.picker.keymaps) :Keymaps)
(nmap! :<leader>hm #(Snacks.picker.marks) :Marks)
(nmap! :<leader>hs #(Snacks.picker.colorschemes) :Colorschemes)
(nmap! :<leader>gb #(Snacks.gitbrowse) "Git browse")
(nmap! :<leader>ss #(Snacks.scratch) "Scratch buffer")
(nmap! :<leader>st #(Snacks.picker.todo_comments) "Todo Comments")
(nmap! :<leader>sS
       #(Snacks.picker.scratch {:win {:input {:keys {:<c-n> {1 :list_down
                                                             :mode [:i]}
                                                     :<c-x> {1 :scratch_delete
                                                             :mode [:n :i]}}}}})
       "Select scratch")

(nmap! :<leader>sI #(Snacks.picker.icons) :Icons)
(nmap! :<leader>gi #(Snacks.picker.gh_issue) :Issue)
(nmap! :<leader>gI #(Snacks.picker.gh_issue {:state :all}) "Issue All")
(nmap! :<leader>gp #(Snacks.picker.gh_pr) :Pr)
(nmap! :<leader>gP #(Snacks.picker.gh_pr {:state :all}) "Pr All")

(autocmd! :User :SnacksDashboardOpened #(set! b miniindentscope_disable true))

; (autocmd! :User :SnacksDashboardOpened
;           #(tset vim.b $1.buf :miniindentscope_disable true))

(require :zfc.mini)
