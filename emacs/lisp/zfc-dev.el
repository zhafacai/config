;;; -*- lexical-binding: t -*-

(use-package completion-preview
  :ensure nil
  :demand t
  :bind
  ( :map completion-preview-active-mode-map
    ("M-i" . completion-preview-insert-word)
    ("M-n" . completion-preview-next-candidate)
    ("M-p" . completion-preview-prev-candidate)
    ("M-<return>" . completion-preview-insert)
    ;; With TAB we effectively defer to the *Completions* buffer to
    ;; show more completion candidates at once.
    ("<tab>" . completion-preview-complete))
  :config
  (setq completion-preview-minimum-symbol-length 2)
  (global-completion-preview-mode 1))

(use-package minibuffer
  :ensure nil
  :demand t
  :bind
  ( :map completion-in-region-mode-map
    ("M-i" . minibuffer-choose-completion)
    ("M-n" . minibuffer-next-completion)
    ("M-p" . minibuffer-previous-completion))
  :config
  (setq completions-format 'one-column)
  (setq completions-max-height 12)
  (setq completion-auto-help t)
  (setq completion-auto-select nil)
  (setq minibuffer-visible-completions t)
  (setq completion-eager-update t))

(use-package corfu
  ;; Optional customizations
  :custom
  (corfu-popupinfo-delay '(0.5 . 0.1))
  ;; (corfu-cycle t)                ;; Enable cycling for `corfu-next/previous'
  ;; (corfu-quit-at-boundary nil)   ;; Never quit at completion boundary
  ;; (corfu-quit-no-match nil)      ;; Never quit, even if there is no match
  ;; (corfu-preview-current nil)    ;; Disable current candidate preview
  ;; (corfu-preselect 'prompt)      ;; Preselect the prompt
  ;; (corfu-on-exact-match 'insert) ;; Configure handling of exact matches

  ;; Enable Corfu only for certain modes. See also `global-corfu-modes'.
  ;; :hook ((prog-mode . corfu-mode)
  ;;        (shell-mode . corfu-mode)
  ;;        (eshell-mode . corfu-mode))
  :bind
  (:map corfu-map
        ("TAB" . corfu-insert)
        ([remap indent-for-tab-command] . corfu-insert)
        ([tab] . corfu-insert))

  :init

  ;; Recommended: Enable Corfu globally.  Recommended since many modes provide
  ;; Capfs and Dabbrev can be used globally (M-/).  See also the customization
  ;; variable `global-corfu-modes' to exclude certain modes.
  (global-corfu-mode)

  ;; Enable optional extension modes:
  ;; (corfu-history-mode)
  (corfu-popupinfo-mode))


;; A few more useful configurations...
(use-package emacs
  :ensure nil
  :custom
  ;; TAB cycle if there are only few candidates
  ;; (completion-cycle-threshold 3)

  ;; Enable indentation+completion using the TAB key.
  ;; `completion-at-point' is often bound to M-TAB.
  (tab-always-indent 'complete)

  ;; Emacs 30 and newer: Disable Ispell completion function.
  ;; Try `cape-dict' as an alternative.
  (text-mode-ispell-word-completion nil)

  ;; Hide commands in M-x which do not apply to the current mode.  Corfu
  ;; commands are hidden, since they are not used via M-x. This setting is
  ;; useful beyond Corfu.
  (read-extended-command-predicate #'command-completion-default-include-p))
(use-package nerd-icons-corfu
  :config
  (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter))

(use-package cape
  ;; Bind prefix keymap providing all Cape commands under a mnemonic key.
  ;; Press C-c p ? to for help.
  :bind ("C-c p" . cape-prefix-map) ;; cape's documented prefix (was C-c c, which collided with org-gtd's C-c c)
  ;; Alternatively bind Cape commands individually.
  ;; :bind (("C-c p d" . cape-dabbrev)
  ;;        ("C-c p h" . cape-history)
  ;;        ("C-c p f" . cape-file)
  ;;        ...)
  :init
  ;; Add to the global default value of `completion-at-point-functions' which is
  ;; used by `completion-at-point'.  The order of the functions matters, the
  ;; first function returning a result wins.  Note that the list of buffer-local
  ;; completion functions takes precedence over the global list.
  (add-hook 'completion-at-point-functions #'cape-dabbrev)
  (add-hook 'completion-at-point-functions #'cape-file)
  (add-hook 'completion-at-point-functions #'cape-elisp-block)
  ;; (add-hook 'completion-at-point-functions #'cape-history)
  ;; ...
  )

(use-package tempel
  :bind (("M-+" . tempel-complete) ;; Alternative tempel-expand
         ("M-*" . tempel-insert))

  :init

  ;; Setup completion at point
  (defun tempel-setup-capf ()
    ;; Add the Tempel Capf to `completion-at-point-functions'.  `tempel-expand'
    ;; only triggers on exact matches. We add `tempel-expand' *before* the main
    ;; programming mode Capf, such that it will be tried first.
    (setq-local completion-at-point-functions
                (cons #'tempel-expand completion-at-point-functions))

    ;; Alternatively use `tempel-complete' if you want to see all matches.  Use
    ;; a trigger prefix character in order to prevent Tempel from triggering
    ;; unexpectly.
    ;; (setq-local corfu-auto-trigger "/"
    ;;             completion-at-point-functions
    ;;             (cons (cape-capf-trigger #'tempel-complete ?/)
    ;;                   completion-at-point-functions))
    )

  (add-hook 'conf-mode-hook 'tempel-setup-capf)
  (add-hook 'prog-mode-hook 'tempel-setup-capf)
  (add-hook 'text-mode-hook 'tempel-setup-capf)

  ;; Optionally make the Tempel templates available to Abbrev,
  ;; either locally or globally. `expand-abbrev' is bound to C-x '.
  ;; (add-hook 'prog-mode-hook #'tempel-abbrev-mode)
  ;; (global-tempel-abbrev-mode)
  )

(use-package tempel-collection)

(use-package yasnippet
  :config
  (yas-global-mode 1))

(use-package yasnippet-snippets)

(use-package apheleia
  :config
  (add-to-list 'apheleia-mode-alist '(scheme-mode . lisp-indent))
  (apheleia-global-mode +1))

(use-package eglot
  :ensure nil
  :bind
  (:map eglot-mode-map
        ("C-c l a" . eglot-code-actions)
        ("C-c l o" . eglot-code-action-organize-imports)
        ("C-c l r" . eglot-rename)
        ("C-c l i" . eglot-inlay-hints-mode)
        ("C-c l f" . eglot-format))
  :hook
  ((python-ts-mode       . eglot-ensure)
   (rustic-mode           . eglot-ensure)
   (typescript-ts-mode     . eglot-ensure)
   (tsx-ts-mode     . eglot-ensure)
   (nix-ts-mode     . eglot-ensure)
   (js-ts-mode             . eglot-ensure)
   (astro-ts-mode             . eglot-ensure)
   (c-mode         . eglot-ensure)
   (bash-ts-mode           . eglot-ensure))

  :custom
  (eglot-autoshutdown         t)
  (eglot-send-changes-idle-time 0.5)

  :config
  (add-to-list 'eglot-server-programs
               '((python-mode python-ts-mode) . ("rass" "python")))

  (add-to-list 'eglot-server-programs
               '(((typescript-ts-mode :language-id "typescript")
                  (tsx-ts-mode :language-id "typescriptreact")
                  (typescript-mode :language-id "typescript")
                  (js-mode :language-id "javascript")
                  (js-ts-mode :language-id "javascript"))
                 . ("rass" "--"
					"tsgo" "--lsp" "--stdio" "--"
					"tailwindcss-language-server" "--stdio"
					))))

(use-package consult-eglot
  :after eglot)

;; DAP debugger for eglot (rust/python/ts...).  Each language needs its
;; debug-adapter binary configured in `dape-adapters'; M-x dape to start.
(use-package dape
  :config
  ;; Save breakpoints across sessions
  (add-hook 'kill-emacs-hook #'dape-breakpoint-save))

(use-package eldoc
  :ensure nil
  :custom
  (eldoc-help-at-pt t)
  (eldoc-echo-area-use-multiline-p nil)
  (eldoc-documentation-strategy #'eldoc-documentation-compose-eagerly)
  (eldoc-echo-area-prefer-doc-buffer nil))

(use-package eldoc-box
  :bind
  (:map eglot-mode-map
        ("C-c l p" . eldoc-box-scroll-down)
        ("C-c l n" . eldoc-box-scroll-up)
        ("C-c l d" . eldoc-box-help-at-point))
  :hook
  (eglot-managed-mode . eldoc-box-hover-mode)
  :config
  (defvar-keymap eldoc-box-repeat-map
    :repeat t
    "n" #'eldoc-box-scroll-up
    "p" #'eldoc-box-scroll-down)
  
  (put 'eldoc-box-scroll-down 'repeat-map 'eldoc-box-repeat-map)
  (put 'eldoc-box-scroll-up 'repeat-map 'eldoc-box-repeat-map))

(use-package flymake
  :ensure nil
  :hook
  (prog-mode . flymake-mode)
  :custom
  (flymake-show-diagnostics-at-end-of-line 'fancy))

(use-package jinx
  :ensure nil
  :hook (emacs-startup . global-jinx-mode)
  :bind (("M-$" . jinx-correct)
         ("C-M-$" . jinx-languages)))

(use-package eros
  :hook (emacs-lisp-mode . eros-mode))

;; step through macro expansions: M-x macrostep-expand
(use-package macrostep)

;; inspector for any elisp object: M-x inspector-inspect-expression
(use-package inspector)

(use-package treesit
  :ensure nil
  :custom
  (treesit-auto-install-grammar 'always)
  (treesit-enabled-modes t))

;; (use-package qml-ts-mode
;;   :vc (:url "https://github.com/xhcoding/qml-ts-mode"))
(use-package markdown-ts-mode
  :ensure nil
  :config
  (add-to-list 'major-mode-remap-alist '(markdown-mode . markdown-ts-mode)))

(provide 'zfc-dev)
