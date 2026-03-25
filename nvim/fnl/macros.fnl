(fn nil? [n]
  (= nil n))

(fn str/begin-with? [str value]
  (not (nil? (string.match str (.. "^" value)))))

(fn ->str [x]
  "sym -> str"
  (tostring x))

(lambda set! [scope key ?value]
  "set options"
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
  "usage: (gh-pkg! \"url\" \"opts\")."
  (pkg! "https://github.com/" url opts))

(lambda map! [mode lhs rhs ?opts]
  "usage: (map! :n \"<leader>f\" \"<cmd>telescope<cr>\" {:desc \"find files\"})
   expand: (vim.keymap.set :n \"<leader>f\" \"<cmd>telescope<cr>\" {:desc \"find files\"})"
  `(vim.keymap.set ,mode ,lhs ,rhs ,?opts))

(lambda nmap! [lhs rhs ?opts]
  "usage: (nmap! \"<leader>f\" \"<cmd>telescope<cr>\" {:desc \"find files\"})
   expand: (vim.keymap.set :n \"<leader>f\" \"<cmd>telescope<cr>\" {:desc \"find files\"})"
  `(vim.keymap.set :n ,lhs ,rhs ,?opts))

(fn autocmd! [event pattern action opts]
  "usage: (autocmd! :BufWritePost \"*.fnl\" #(print \"Saved!\") {:desc \"description\"})
   expand: (vim.api.nvim_create_autocmd :BufWritePost {:pattern \"*.fnl\" :callback ...})"
  (assert-compile (or (list? action) (str? action))
                  "ACTION should be string/list." action)
  (let [opts (or opts {})]
    (tset opts :pattern pattern)
    (if (list? action)
        (tset opts :callback action)
        (tset opts :command action))
    `(vim.api.nvim_create_autocmd ,event ,opts)))

{: gh-pkg! : nmap! : map! : set! : autocmd! : seto!}
