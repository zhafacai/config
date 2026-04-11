(import-macros {: gh-pkg! : nmap! : map! : set! : autocmd!} :macros)

(gh-pkg! :nvim-lua/plenary.nvim)

(gh-pkg! :rktjmp/paperplanes.nvim {:setup {}})

(gh-pkg! :NeogitOrg/neogit {:setup {}})
(nmap! :<leader>gg :<cmd>Neogit<CR> "Open Neogit")

(gh-pkg! :pwntester/octo.nvim {:setup {:picker :default}})
(gh-pkg! :esmuellert/codediff.nvim {:setup {}})
(nmap! :<leader>gd :<cmd>CodeDiff<CR> "Open CodeDiff")

(gh-pkg! :MagicDuck/grug-far.nvim {:setup {}})
(nmap! :<leader>sf :<cmd>GrugFar<CR> "Open GrugFar")

(gh-pkg! :mikavilpas/yazi.nvim {:setup {}})
(nmap! :<a-e> :<cmd>Yazi<cr> "Open Yazi")

(gh-pkg! :nvzone/volt)
(gh-pkg! :nvzone/floaterm
         {:setup {:terminals [{:name :Terminal}
                              {:name :Terminal}
                              {:name :Terminal}]}})

(map! [:n :t] :<a-i> :<CMD>FloatermToggle<CR> "Toggle floaterm")

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

(nmap! "-" :<CMD>Oil<CR> "Open parent directory")

(gh-pkg! :stevearc/conform.nvim
         {:setup {:format_on_save {:timeout_ms 500 :lsp_format :fallback}
                  :formatters_by_ft {:lua [:stylua]
                                     :sh [:shfmt]
                                     :markdown [:rumdl]
                                     :toml [:tombi]
                                     :python [:black]
                                     :fennel [:fnlfmt]
                                     :nix [:nixfmt]
                                     :json [:jq]
                                     :rust [:rustfmt]
                                     :fennel [:fnlfmt]}}})

(gh-pkg! :lambdalisue/vim-suda)

(gh-pkg! :benoror/gpg.nvim)
; (gh-pkg! :icarios-dev/privymd.nvim {:setup {}})
(gh-pkg! :HakonHarnes/img-clip.nvim {:setup {}})
(nmap! :<leader>p :<Cmd>PasteImage<CR> "Paste image")

(gh-pkg! :zhafacai/authinfo.nvim {:setup {}})
(gh-pkg! :olimorris/codecompanion.nvim)
(let [cca (require :codecompanion.adapters)
      qwen-code (cca.extend :gemini_cli
                            {:commands {:default [:qwen :--acp]
                                        :yolo [:qwen :--yolo :--acp]}
                             :defaults {:auth_method :qwen-oauth
                                        :oauth_credentials_path (vim.fs.abspath "~/.qwen/oauth_creds.json")}
                             :formatted_name "Qwen Code"
                             :handlers {:auth (fn [self]
                                                (let [path self.defaults.oauth_credentials_path]
                                                  (= 1
                                                     (and path
                                                          (vim.fn.filereadable path)))))}
                             :name :qwen_code})
      openrouter #(cca.extend :openai_compatible
                              {:schema {:model {:default "nvidia/nemotron-3-super-120b-a12b:free"
                                                :choices ["nvidia/nemotron-3-super-120b-a12b:free"
                                                          "minimax/minimax-m2.5:free"
                                                          "arcee-ai/trinity-large-preview:free"
                                                          "google/gemma-4-26b-a4b-it:free"
                                                          "google/gemma-4-31b-it:free"
                                                          "liquid/lfm-2.5-1.2b-instruct:free"
                                                          "liquid/lfm-2.5-1.2b-thinking:free"]}}
                               :env {:api_key (. AUTHINFO :api.opencode.ai
                                                 :password)
                                     :chat_url :/v1/chat/completions
                                     :url "https://openrouter.ai/api"}})]
  (gh-pkg! :olimorris/codecompanion.nvim
           {:setup {:interactions {:chat {:adapter :opencode}
                                   :cli {:agent :opencode
                                         :agents {:opencode {:cmd :opencode
                                                             :args []
                                                             :description "OpenCode Cli"
                                                             :provider :terminal}}}
                                   :inline {:adapter :openrouter}
                                   :cmd {:adapter :opencode}}
                    :adapters {:http {: openrouter} :acp {: qwen-code}}
                    :prompt_library {:markdown {:dirs [(vim.fn.expand "~/dots/prompts/")]}}}}))

(map! [:n :v] :<leader>cp :<cmd>CodeCompanion<CR> "Toggle CodeCompanion panel")
(map! [:n :v] :<leader>cc :<cmd>CodeCompanionChat<CR> "Open CodeCompanion chat")
(map! [:n :v] :<leader>ca :<cmd>CodeCompanionActions<CR>
      "Open CodeCompanion actions")

(map! [:n :v] :<leader>cr :<cmd>CodeCompanionReview<CR>
      "Review code with CodeCompanion")

(vim.cmd "cab cc CodeCompanion")

;; for antifennel-nvim
(gh-pkg! :Olical/aniseed)
(gh-pkg! :elkowar/antifennel-nvim)
(gh-pkg! :Olical/conjure)
(gh-pkg! :Olical/nfnl)
(set! g conjure#filetypes [:fennel :scheme])
