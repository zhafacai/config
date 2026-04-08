;; [nfnl-macro]

(fn nil? [n]
  (= nil n))

(fn str/begin-with? [str value]
  (not (nil? (string.match str (.. "^" value)))))

(fn ->str [x]
  "sym -> str"
  (tostring x))

(lambda set! [scope key ?value]
  "Set a scoped variable or option value.
   Scopes: :g (global), :w (window), :b (buffer).
   Options: :o (vim.opt). Handles %+ append, %- remove, :no toggle.
   Arguments: scope keyword/sym, key string/sym, ?value optional."
  (assert-compile (sym? scope) "expected sym for scope")
  (assert-compile (sym? key) "expected sym for key")
  (let [scope (->str scope)
        key (->str key)]
    (match scope
      :g `(tset vim.g ,key ,?value)
      :w `(tset vim.w ,key ,?value)
      :b `(tset vim.b ,key ,?value)
      :o (if (str/begin-with? key "%+")
             `(: (. vim.opt ,(string.sub key 2)) :append ,?value)
             (str/begin-with? key "%-")
             `(: (. vim.opt ,(string.sub key 2)) :remove ,?value)
             (str/begin-with? key :no)
             `(tset vim.opt ,(string.sub key 3) false)
             (nil? ?value)
             `(tset vim.opt ,key true)
             `(tset vim.opt ,key ,?value)))))

(lambda seto! [key ?value]
  `(set! o ,key ,?value))

(fn str? [s]
  (= :string (type s)))

(fn pkg! [host url opts]
  "Pack a plugin from a given host and repository URL.
  
  Usage:
    (pkg! \"https://github.com/\" \"username/repo\" {:setup ... :name ...})
  
  Args:
    - host: Base URL host (string)
    - url: Repository path (string)
    - opts: Configuration table with optional :setup and :name keys"
  (assert-compile (str? host) "HOST should be string." host)
  (assert-compile (str? url) "URL should be string." url)
  (let [opts (or opts {})
        repo-name (or (url:match "/([^/]+)$") url)
        module-name (repo-name:gsub "%.nvim$" "")
        setup-val (. opts :setup)
        module-name (or (. opts :name) module-name)
        pack-opts (collect [k v (pairs opts)]
                    (if (and (not= k :name) (not= k :setup)) (values k v)))]
    (tset pack-opts :src (.. host url))
    `(do
       (vim.pack.add [,pack-opts])
       ,(when (table? setup-val)
          `((. (require ,module-name) :setup) ,setup-val)))))

(fn gh-pkg! [url opts]
  "Pack a plugin specifically from GitHub using a repository path.
  
  Usage:
    (gh-pkg! \"username/repo\" {:setup ... :name ...})"
  (pkg! "https://github.com/" url opts))

(lambda map! [mode lhs rhs ?opts]
  "Set a global keymap binding.
  
  Usage:
    (map! :n \"<leader>f\" \"<cmd>Telescope find_files<cr>\" \"Find files\")
    (map! :n \"<leader>f\" \"<cmd>Telescope find_files<cr>\" {:desc \"Find files\"})
  
  Expands to:
    (vim.keymap.set :n \"<leader>f\" \"<cmd>Telescope find_files<cr>\" {:desc \"Find files\"})"
  (let [opts (if (and ?opts (str? ?opts))
                 {:desc ?opts}
                 ?opts)]
    `(vim.keymap.set ,mode ,lhs ,rhs ,opts)))

(lambda nmap! [lhs rhs ?opts]
  "Set a keymap binding for normal mode.
  
  Usage:
    (nmap! \"<leader>f\" \"<cmd>Telescope find_files<cr>\" \"Find files\")
    (nmap! \"<leader>f\" \"<cmd>Telescope find_files<cr>\" {:desc \"Find files\"})
  
  Expands to:
    (vim.keymap.set :n \"<leader>f\" \"<cmd>Telescope find_files<cr>\" {:desc \"Find files\"})"
  (map! :n lhs rhs ?opts))

(fn augroup! [name & body]
  "Create an augroup with nested autocmds, Vimscript-style.\r
   Usage:\r
     (augroup! :mydata\r
       (autocmd! :BufWritePost \"*.fnl\" handler)\r
       (autocmd! :BufReadPost \"*.fnl\" handler2 {:desc \"Load\"}))"
  (let [group (tostring name)]
    (let [group `(vim.api.nvim_create_augroup ,group {:clear true})]
      (fcollect [i 1 (length body)]
        (match (. body i)
          (where [cmd e p a] (= (tostring cmd) :autocmd!))
          ;; simple 
          `(,cmd ,e ,p ,a {:group ,group})
          (where [cmd e p a o] (= (tostring cmd) :autocmd!))
          ;; with opts
          `(,cmd ,e ,p ,a (doto ,o (tset :group ,group)))
          x
          x)))))

(lambda autocmd! [event pattern action ?opts]
  "Create a custom autocommand event handler.
  
  Usage:
    (autocmd! :BufWritePost \"*.fnl\" #(print \"Saved!\") {:desc \"On save\")
  
  Expands to:
    (vim.api.nvim_create_autocmd :BufWritePost {:pattern \"*.fnl\" :callback ...})"
  (assert-compile (or (list? action) (str? action))
                  "ACTION should be string/list." action)
  (let [opts (or ?opts {})]
    (tset opts :pattern pattern)
    (if (list? action)
        (tset opts :callback action)
        (tset opts :command action))
    `(vim.api.nvim_create_autocmd ,event ,opts)))

{: gh-pkg! : nmap! : map! : set! : autocmd! : seto! : augroup!}
