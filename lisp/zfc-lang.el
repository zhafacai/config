(use-package uiua-mode
  :mode "\\.ua\\'")

(use-package sol-mode
  :mode "\\.sol\\'")

;; NOTE https://github.com/liblit/demangle-mode this one might be helpful
(use-package disaster
  :commands (disaster)
  :init
  (setq disaster-assembly-mode #'nasm-mde))
;; TODO use map like this
;; (map! :localleader
;;       :map (c++-mode-map c-mode-map)
;;       :desc "Disaster" "d" #'disaster))
(use-package cmake-mode)

(use-package uv-mode
  :hook (python-ts-mode . uv-mode-auto-activate-hook))

(add-to-list 'major-mode-remap-alist
             '(rust-mode . rustic-mode))

(use-package rust-mode
  :custom
  (rust-mode-treesitter-derive t))

(use-package rustic
  :custom
  (rustic-lsp-client 'eglot)
  (rustic-format-on-save t))

;; (use-package lsp-tailwindcss
;;   :init
;;   (setq lsp-tailwindcss-add-on-mode t)
;;   :after lsp-mode)

(use-package fennel-mode
  :mode "\\.fnl\\'")

(use-package kdl-mode)
;; (use-package qml-ts-mode)

;; (use-package justl)
(use-package just-ts-mode)

(provide 'zfc-lang)
