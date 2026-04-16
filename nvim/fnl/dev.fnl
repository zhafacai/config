(import-macros {: autocmd! : set! : gh-pkg! : nmap! : map!} :macros)

;; Completion
(gh-pkg! :rafamadriz/friendly-snippets)

(gh-pkg! :chrisgrieser/nvim-scissors)
(let [scissors (require :scissors)]
  (nmap! :<leader>se #(scissors.editSnippet) "Snippet: Edit")
  (map! [:n :x] :<leader>sa #(scissors.addNewSnippet) "Snippet: Add"))

(gh-pkg! :mikavilpas/blink-ripgrep.nvim)
(gh-pkg! :moyiz/blink-emoji.nvim)
;; NOTE: maybe drop these fancy plugins when blink.cmp is ready.
(gh-pkg! :xzbdmw/colorful-menu.nvim {:setup {}})
(gh-pkg! :onsails/lspkind.nvim)
(gh-pkg! :saghen/blink.cmp {:version (vim.version.range "*")})
(require :zfc.blink)

;; Lsp
(gh-pkg! :neovim/nvim-lspconfig)
(let [ser [:tsgo :lua_ls :ty :zls :clangd :tailwindcss :nixd :jsonls :org]]
  (vim.lsp.enable ser))

(gh-pkg! :mfussenegger/nvim-lint)
(let [lint (require :lint)
      linters {:python [:ruff] :markdown [:rumdl]}]
  (autocmd! :BufWritePost "*" #(lint.try_lint))
  (tset lint :linters_by_ft linters))

(gh-pkg! :folke/lazydev.nvim
         {:setup {:library [{:path "${3rd}/luv/library" :words ["vim%.uv"]}]}})

(gh-pkg! :rachartier/tiny-code-action.nvim
         {:setup {:backend :vim
                  :picker {1 :buffer
                           :opts {:auto_preview true
                                  :hotkeys true
                                  :hotkeys_mode :text_based}}}})

; (let [ca (require :tiny-code-action)]
;   (map! [:n :x] :gra (ca.code_action)))

;; Move
(gh-pkg! :chrisgrieser/nvim-spider)
(let [spider-motion #(let [m $1]
                       (.. "<cmd>lua require('spider').motion('" m "')<CR>"))]
  (map! [:n :o :x] :w (spider-motion :w) "Spider: w")
  (map! [:n :o :x] :e (spider-motion :e) "Spider: e")
  (map! [:n :o :x] :b (spider-motion :b) "Spider: b")
  (map! [:n :o :x] :ge (spider-motion :ge) "Spider: ge"))

(gh-pkg! :farmergreg/vim-lastplace)

(gh-pkg! :max397574/better-escape.nvim
         {:setup {:mappings {:t {:j {:k false}}}} :name :better_escape})

(gh-pkg! :folke/flash.nvim {:setup {:label {:uppercase false}}})
(let [flash (require :flash)]
  (map! [:n :x :o] :<c-s> #(flash.jump) "Flash jump")
  (nmap! :S #(flash.treesitter) "Flash treesitter")
  ;; NOTE these mappings are used by textobjs
  ;; (map! :o :r #(flash.remote))
  ;; (map! [:o :x] :R #(flash.treesitter_search))
  (map! :c :<c-s> #(flash.toggle) "Flash toggle"))

;; Treesitter
(gh-pkg! :nvim-treesitter/nvim-treesitter)
(let [ts-fts [:typescript
              :lua
              :html
              :yaml
              :comment
              :fennel
              :bpftrace
              :cpp
              :nix
              :python]
      nts (require :nvim-treesitter)]
  (nts.install ts-fts)
  (autocmd! :FileType ts-fts
            #(do
               (vim.treesitter.start)
               (set! o indentexpr "v:lua.require'nvim-treesitter'.indentexpr()"))))

(gh-pkg! :windwp/nvim-ts-autotag {:setup {}})
(gh-pkg! :chrisgrieser/nvim-various-textobjs
         {:setup {:keymaps {:useDefaults true}} :name :various-textobjs})

;; Database
(set! g db_ui_use_nerd_fonts 1)
(gh-pkg! :kristijanhusak/vim-dadbod-ui)
(gh-pkg! :tpope/vim-dadbod)
(gh-pkg! :kristijanhusak/vim-dadbod-completion)
(nmap! :<leader>td #(vim.cmd.DBUIToggle) "DBUI toggle")

;; Comments
(gh-pkg! :folke/ts-comments.nvim)

;; Rust
(set! g rustaceanvim
      {:server {:default_settings {:rust-analyzer {:rustfmt {:extraArgs [:+nightly]}}}
                :on_attach (fn [] (vim.lsp.inlay_hint.enable true))}})

(gh-pkg! :mrcjkb/rustaceanvim)

(autocmd! :FileType :rust
          #(do
             (nmap! :gra #(vim.cmd.RustLsp :codeAction)
                    {:buffer true :desc "Rust: Code Action"})
             (nmap! :K #(vim.cmd "RustLsp hover actions")
                    {:buffer true :desc "Rust: Hover Actions"})
             (map! [:v] :K #(vim.cmd "RustLsp hover range")
                   {:buffer true :desc "Rust: Hover Range"})
             (nmap! :<leader>dr #(vim.cmd.RustLsp :runnables)
                    {:buffer true :desc "Rust: Runnables"})
             (nmap! :<leader>dd #(vim.cmd.RustLsp :debuggables)
                    {:buffer true :desc "Rust: Debuggables"})
             (nmap! :<leader>dt #(vim.cmd.RustLsp :testables)
                    {:buffer true :desc "Rust: Testables"})
             (nmap! :<leader>de #(vim.cmd.RustLsp :expandMacro)
                    {:buffer true :desc "Rust: Expand Macro"})
             (nmap! :<leader>dm #(vim.cmd.RustLsp :moveItem)
                    {:buffer true :desc "Rust: Move Item"})
             (nmap! :<leader>dx #(vim.cmd.RustLsp :renderDiagnostic)
                    {:buffer true :desc "Rust: Render Diagnostic"})
             (nmap! :<leader>do #(vim.cmd.RustLsp :openDocs)
                    {:buffer true :desc "Rust: Open Docs"})
             (nmap! :<leader>dc #(vim.cmd.RustLsp :openCargo)
                    {:buffer true :desc "Rust: Open Cargo"})
             (nmap! :<leader>dj #(vim.cmd.RustLsp :joinLines)
                    {:buffer true :desc "Rust: Join Lines"})
             (nmap! :<leader>dw #(vim.cmd.RustLsp :workspaceSymbol)
                    {:buffer true :desc "Rust: Workspace Symbol"})
             (nmap! :<leader>dp #(vim.cmd.RustLsp :parentModule)
                    {:buffer true :desc "Rust: Parent Module"})
             (nmap! :<leader>dy #(vim.cmd.RustLsp :explainError)
                    {:buffer true :desc "Rust: Explain Error"})
             (nmap! :<leader>dg #(vim.cmd.RustLsp :relatedDiagnostics)
                    {:buffer true :desc "Rust: Related Diagnostics"})))

;; Cpp
(gh-pkg! :dchinmay2/clangd_extensions.nvim)
;; Json
(gh-pkg! :b0o/schemastore.nvim)
(let [scm (require :schemastore)]
  (vim.lsp.config :jsonls
                  {:settings {:json {:schemas (scm.json.schemas)
                                     :validate {:enable true}}}}))

;; moonbit
(gh-pkg! :moonbit-community/moonbit.nvim {:setup {}})

;; test
(gh-pkg! :nvim-neotest/nvim-nio)
(gh-pkg! :nvim-neotest/neotest-python)
(gh-pkg! :marilari88/neotest-vitest)
(gh-pkg! :nvim-neotest/neotest)
(let [py (require :neotest-python)
      vi (require :neotest-vitest)
      mn (require :neotest-moonbit)
      rt (require :rustaceanvim.neotest)]
  (gh-pkg! :nvim-neotest/neotest {:setup {:adapters [py vi rt mn]}}))

(let [nt (require :neotest)]
  (nmap! :<leader>tf #(nt.run.run (vim.fn.expand "%")) "test file")
  (nmap! :<leader>tt #(nt.run.run) "test nearest")
  (nmap! :<leader>tw #(nt.watch.toggle) "test watch")
  (nmap! :<leader>to #(nt.output_panel.toggle) "test output_panel")
  (nmap! :<leader>ts #(nt.summary.toggle) "test summary"))

(gh-pkg! :chrisgrieser/nvim-puppeteer)

(gh-pkg! :chrisgrieser/nvim-chainsaw {:setup {} :name :chainsaw})
(let [cs (require :chainsaw)]
  (nmap! :gll #(cs.variableLog) "Chainsaw: log variable")
  (nmap! :glo #(cs.objectLog) "Chainsaw: log object")
  (nmap! :glt #(cs.typeLog) "Chainsaw: log type")
  (nmap! :gla #(cs.assertLog) "Chainsaw: log assert")
  (nmap! :gle #(cs.emojiLog) "Chainsaw: log emoji")
  (nmap! :glm #(cs.messageLog) "Chainsaw: log message")
  (nmap! :glt #(cs.timeLog) "Chainsaw: log time")
  (nmap! :gls #(cs.stacktraceLog) "Chainsaw: log stacktrace")
  (nmap! :glc #(cs.clearLog) "Chainsaw: clear log")
  (nmap! :glr #(cs.removeLog) "Chainsaw: remove log")
  (nmap! :gld #(cs.debugLog) "Chainsaw: debug log"))
