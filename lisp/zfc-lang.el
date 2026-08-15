;;; -*- lexical-binding: t -*-
(use-package uiua-mode
  :mode "\\.ua\\'")

(use-package sol-mode
  :mode "\\.sol\\'")

(use-package nix-ts-mode
 :mode "\\.nix\\'")

;; NOTE https://github.com/liblit/demangle-mode this one might be helpful
(use-package disaster
  :commands (disaster)
  :init
  (setq disaster-assembly-mode #'nasm-mode))
;; (Disaster is only autoloaded; bind it per-mode with use-package :bind if
;;  wanted.  The Doom `map!' macro is not used in this config anymore.)
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
