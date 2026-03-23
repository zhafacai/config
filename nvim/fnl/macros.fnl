; (fn set! [scope key value]
;   "usage: (set! g mapleader \",\").
;   expand: (tset vim.g :mapleader \",\")."
;   (assert-compile (sym? scope) "scope must be a symbol (g, b, w, o, v)" scope)
;   (let [scope-str (tostring scope)
;         key (tostring key)
;         vim-scope (.. :vim. scope-str)]
;     `(tset ,(sym vim-scope) ,key ,value)))
;

(fn nil? [n]
  (= nil n))

(fn str/begin-with? [str value]
  (not (nil? (string.match str (.. "^" value)))))

(fn ->str [x]
  :tostring
  (tostring x))

(lambda set! [scope key ?value]
  "set options"
  (assert-compile (sym? scope) "expected sym for scope")
  (assert-compile (sym? key) "expected sym for key")
  (let [scope (->str scope)
        key (->str key)]
    (match scope
      :g `(tset vim.g ,key ,?value)
      :o (if (str/begin-with? key "%+")
             `(: (. vim.opt ,(string.sub key 2)) :append ,?value)
             (str/begin-with? key "%-")
             `(: (. vim.opt ,(string.sub key 2)) :remove ,?value)
             (let [begin-with-no (str/begin-with? key :no)]
               (if begin-with-no `(tset vim.opt ,(string.sub key 3) false)
                   (nil? ?value) `(tset vim.opt ,key true)
                   `(tset vim.opt ,key ,?value)))))))
(fn str? [s]
  (= :string (type s)))

(fn pkg! [host url opts]
  (assert-compile (str? host) "HOST should be string." host)
  (assert-compile (str? url) "URL should be string." url)
  (let [
        opts (or opts {}) 
        repo-name (match (url:match "/([^/]+)$") n n _ url)
        module-name (repo-name:gsub "%.nvim$" "")
        setup-val (. opts :setup)
        module-name (or (. opts :name) module-name)
        pack-opts (collect [k v (pairs opts)]
                    (if (and (not= k :name) (not= k :setup)) (values k v)))]
    (tset pack-opts :src (.. host url))
    `(do
       (vim.pack.add [,pack-opts])
       ,(if (list? setup-val) `(,setup-val)
            (= :table (type setup-val)) `((. (require ,module-name) :setup) ,setup-val)
            nil))))

(fn gh-pkg! [url opts]
  "usage: (gh-pkg! \"url\" \"opts\")."
  (pkg! "https://github.com/" url opts))

(fn map! [mode lhs rhs opts]
  "usage: (map! :n \"<leader>f\" \"<cmd>telescope<cr>\" {:desc \"find files\"})
   expand: (vim.keymap.set :n \"<leader>f\" \"<cmd>telescope<cr>\" {:desc \"find files\"})"
  (let [
        opts (or opts {})]
    `(vim.keymap.set ,mode ,lhs ,rhs ,opts)))

(fn nmap! [lhs rhs opts]
  "usage: (nmap! \"<leader>f\" \"<cmd>telescope<cr>\" {:desc \"find files\"})
   expand: (vim.keymap.set :n \"<leader>f\" \"<cmd>telescope<cr>\" {:desc \"find files\"})"
  (let [
        opts (or opts {})]
    `(vim.keymap.set :n ,lhs ,rhs ,opts)))

(fn autocmd! [event pattern action opts]
  "usage: (autocmd! :BufWritePost \"*.fnl\" #(print \"Saved!\") {:desc \"description\"})
   expand: (vim.api.nvim_create_autocmd :BufWritePost {:pattern \"*.fnl\" :callback ...})"
  (let [opts (or opts {})]
    (tset opts :pattern pattern)
    (if (list? action)
        (tset opts :callback action) 
        (tset opts :command action))
    `(vim.api.nvim_create_autocmd ,event ,opts)))

{: gh-pkg! : nmap! : map! : set! : autocmd!}
