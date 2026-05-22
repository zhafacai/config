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
(with-eval-after-load 'yasnippet
  (keymap-unset yas-minor-mode-map "TAB")
  (keymap-unset yas-minor-mode-map "<tab>"))
(defun my/tab ()
  (interactive)
  (cond
   ;; corfu popup
   ((and (bound-and-true-p corfu-mode)
         (boundp 'corfu--candidates)
         corfu--candidates)
    (corfu-insert))

   ;; snippet
   ((and (bound-and-true-p yas-minor-mode)
         (yas-expand)))

   ;; default
   (t
    (indent-for-tab-command))))
(global-set-key (kbd "TAB") #'my/tab)
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
  :bind ("C-c c" . cape-prefix-map) ;; Alternative key: M-<tab>, M-p, M-+
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
  :defer t
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
  (eglot-send-changes-idle-time 0.5) ;; send changes faster (default is 0.5 anyway)

  ;; (eglot-ignored-server-capabilities
  ;;  '(:documentHighlightProvider      ;; disable if too slow/noisy
  ;;    :foldingRangeProvider
  ;;    ))            ;; many people disable inlay hints or use a dedicated package

  ;; 3. Optional: better event logging (useful when debugging)
  ;; :custom (eglot-events-buffer-size 2000000)  ;; bigger log buffer

  :config
  (add-to-list 'eglot-server-programs
               '((python-mode python-ts-mode) . ("ty" "server")))

  (add-to-list 'eglot-server-programs
               '(((typescript-ts-mode :language-id "typescript")
                  (tsx-ts-mode :language-id "typescriptreact")
                  (typescript-mode :language-id "typescript")
                  (js-mode :language-id "javascript")
                  (js-ts-mode :language-id "javascript"))
                 . ("tsgo" "--lsp" "--stdio")))

  (add-to-list 'eglot-server-programs
               '(tsx-ts-mode . ("tailwindcss-language-server" "--stdio")))

  (general-define-key
   :states 'normal
   :keymaps 'eglot-mode-map
   "grn" 'eglot-rename
   "gra" 'eglot-code-actions))

(use-package consult-eglot
  :after eglot
  :config
  (evil-define-key 'normal eglot-mode-map
    "gO" #'consult-eglot-symbols))

(use-package eldoc
  :ensure nil
  :custom
  (eldoc-echo-area-use-multiline-p nil)
  ;; (eldoc-documentation-strategy #'eldoc-documentation-compose-eagerly)
  (eldoc-echo-area-prefer-doc-buffer nil))

(use-package eldoc-box
  :hook
  (eglot-managed-mode . eldoc-box-hover-mode)
  :config
  (evil-define-key 'normal eglot-mode-map "K" #'eldoc-box-help-at-point))

;; (use-package eldoc-mouse
;;   :config
;;   (evil-define-key 'normal eglot-mode-map "K" #'eldoc-mouse-pop-doc-at-cursor))

(use-package flymake
  :ensure nil
  :hook
  (prog-mode . flymake-mode)
  :custom
  (flymake-show-diagnostics-at-end-of-line 'fancy)
  :config
  (evil-global-set-key 'normal (kbd "]d") 'flymake-goto-next-error)
  (evil-global-set-key 'normal (kbd "[d") 'flymake-goto-prev-error)
  (fc/map 'normal
    "xx" #'flymake-show-buffer-diagnostics
    "xp" #'flymake-show-buffer-diagnostics))

(use-package xref
  :ensure nil
  :bind (:map evil-motion-state-map
              ("gd" . xref-find-definitions)))

(use-package treesit
  :ensure nil)

(use-package treesit-auto
  :custom
  (treesit-auto-install 'prompt)
  :config
  ;; (after! org
  ;;   (dolist (mode
  ;;            '(("cmake"      . cmake-ts)
  ;;              ("dockerfile" . dockerfile-ts)
  ;;              ("go"         . go-ts)
  ;;              ("lua"        . lua-ts)
  ;;              ("rust"       . rust-ts)
  ;;              ("typescript" . typescript-ts)
  ;;              ("yaml"       . yaml-ts)))
  ;;     (add-to-list 'org-src-lang-modes mode)))
  
  (treesit-auto-add-to-auto-mode-alist 'all)

  ;; FIXME cannot make this work
  (add-to-list 'treesit-auto-recipe-list (make-treesit-auto-recipe
                                          :lang 'qmljs
                                          :ts-mode 'qml-ts-mode
                                          :remap 'qml-mode
                                          :url "https://github.com/yuja/tree-sitter-qmljs"
                                          :ext "\\.qml\\'"))
  (add-to-list 'treesit-auto-langs 'qmljs)
  (global-treesit-auto-mode))

(use-package qml-ts-mode
  :ensure (:host github :repo "xhcoding/qml-ts-mode"))

(use-package evil-textobj-tree-sitter
  :config
  (evil-define-motion evil-motion-to-next-closing-quote (count)
    "Move to the next closing quote ', \", or `."
    :type exclusive
    (let ((found (save-excursion (search-forward-regexp "['\"`]" nil t))))
      (if found
          (goto-char (1- found))
        (error "No closing quote found"))))

  (define-key evil-operator-state-map "Q" 'evil-motion-to-next-closing-quote)
  (define-key evil-visual-state-map "Q" 'evil-motion-to-next-closing-quote)
  (evil-define-motion evil-motion-to-next-closing-bracket (count)
    "Move to the next closing bracket ), ], or }."
    :type exclusive
    (let ((found (save-excursion (search-forward-regexp "[]})]" nil t))))
      (if found
          (goto-char (1- found))
        (error "No closing bracket found"))))

  (define-key evil-operator-state-map "C" 'evil-motion-to-next-closing-bracket)
  (define-key evil-visual-state-map "C" 'evil-motion-to-next-closing-bracket)

  (evil-define-text-object evil-any-quote-inner (count &optional beg end type)
    (let ((range (evil-select-quote ?\" beg end type count nil)))
      (dolist (char '(?\' ?\`))
        (let ((new (evil-select-quote char beg end type count nil)))
          (when (and new (> (car new) (car (or range '(0)))) )
            (setq range new))))
      range))

  (evil-define-text-object evil-any-quote-outer (count &optional beg end type)
    (let ((range (evil-select-quote ?\" beg end type count t)))
      (dolist (char '(?\' ?\`))
        (let ((new (evil-select-quote char beg end type count t)))
          (when (and new (> (car new) (car (or range '(0)))) )
            (setq range new))))
      range))

  (define-key evil-inner-text-objects-map "q" 'evil-any-quote-inner)
  (define-key evil-outer-text-objects-map "q" 'evil-any-quote-outer)

  (evil-define-text-object evil-textobj-url (count &optional beg end type)
    "Select inner URL using standard Emacs 'thing-at-point'."
    (cl-destructuring-bind (start . end)
        (bounds-of-thing-at-point 'url)
      (evil-range start end)))

  (define-key evil-operator-state-map "L" 'evil-textobj-url)
  (define-key evil-visual-state-map "L" 'evil-textobj-url))

(provide 'zfc-dev)
