;; -*- lexical-binding: t; -*-
(setq package-archives '(("gnu" . "https://mirrors.ustc.edu.cn/elpa/gnu/")
                         ("melpa" . "https://mirrors.ustc.edu.cn/elpa/melpa/")
                         ("nongnu" . "https://mirrors.ustc.edu.cn/elpa/nongnu/")))
(setq use-package-always-ensure t)
(package-initialize)

(defun fc/org-auto-tangle-config ()
  "Tangle only if the saved file is config.org"
  (when  (string-equal (buffer-file-name)
                       (expand-file-name "~/dots/config.org"))
    (let ((org-confirm-babel-evaluate nil))
      (org-babel-tangle))))

(add-hook 'org-mode-hook
          (lambda ()
            (add-hook 'after-save-hook #'fc/org-auto-tangle-config nil 'local)))

;; Instruct Emacs to use a posix shell under the hood...
(setq shell-file-name (executable-find "bash"))

;; But use your normal shell in terminal emulators
(setq-default vterm-shell (executable-find "fish"))
(setq-default explicit-shell-file-name (executable-find "fish"))

(recentf-mode)
(use-package isearch
  :ensure nil
  :custom
  (isearch-lazy-count t))

(use-package gcmh
  :config
  (gcmh-mode 1))

(setq-default indent-tabs-mode nil
              tab-width 4)

(setq custom-file (make-temp-file "emacs-custom-"))

;; (setq custom-safe-themes t)

(defvar fc/leader-key "SPC"
  "my leader key.")

(defvar fc/localleader-key ","
  "my local leader key.")

(use-package general)

(general-create-definer fc/map
  :prefix fc/leader-key)

(defmacro after! (features &rest body)
  "在指定的 feature(s) 加载完成后执行 body。
第一个参数 features 支持：
  - 单个 symbol，例如：evil
  - 多个 feature 的列表，例如：(org evil magit)

如果是列表，会自动展开成嵌套的 with-eval-after-load 结构。
加载顺序：列表从左到右（最外层先加载）。

示例：
(after! evil
  (evil-define-key 'normal global-map (kbd \"C-c t\") #'treemacs))

(after! (org evil)
  (map! :map org-mode-map
        :n \"<tab>\" #'org-cycle))

(after! (magit forge)
  (setq forge-topic-list-limit '(50 . 100)))
"
  (declare (indent 1) (debug t))

  ;; 输入检查
  (unless (or (symbolp features) (consp features))
    (error "after! 的第一个参数必须是 symbol 或 list"))

  ;; 统一转成列表
  (let ((fs (if (symbolp features)
                (list features)
              features))
        ;; 使用 `,@' 展开 body，避免被包装成 list
        (form `(progn ,@body)))

    ;; 从列表尾部开始往外包
    (dolist (f (reverse fs))
      (setq form `(with-eval-after-load ',f
                    ,form)))

    form))

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

(setq help-at-pt-display-when-idle t) 
(setq initial-scratch-message ";; What's the QUESTION today?\n\n")

(defun fc/toggle-alpha-background ()
  "toggle tranparency of background"
  (interactive)
  (let ((current (frame-parameter nil 'alpha-background)))
    (set-frame-parameter nil 'alpha-background
                         (if (or (null current) (>= current 98))
                             90
                           100))))
(add-to-list 'default-frame-alist '(alpha-background . 90))

(fc/map 'normal "ta" #'fc/toggle-alpha-background)

(use-package page-break-lines)

(use-package modus-themes
  :demand t
  :init
  (modus-themes-include-derivatives-mode 1)
  :bind
  (("<f5>" . modus-themes-rotate)
   ("C-<f5>" . modus-themes-select)
   ("M-<f5>" . modus-themes-load-random))
  :config
  ;; Your customizations here:
  (setq modus-themes-to-toggle '(modus-operandi modus-vivendi)
        modus-themes-to-rotate modus-themes-items
        modus-themes-mixed-fonts t
        modus-themes-variable-pitch-ui t
        modus-themes-italic-constructs t
        modus-themes-bold-constructs t
        modus-themes-completions '((t . (bold)))
        modus-themes-prompts '(bold)
        modus-themes-headings
        '(
          ;; (agenda-structure . (variable-pitch light 2.2))
          ;; (agenda-date . (variable-pitch regular 1.3))
	  ;; (t . (regular 1.15))
	  ))

  (setq modus-themes-common-palette-overrides nil))

(use-package ef-themes
  :init
  (ef-themes-take-over-modus-themes-mode 1))

(set-face-attribute 'default nil
                    :family "Iosevka SS02"
                    :height 150)

(set-face-attribute 'variable-pitch nil
                    :family "Aporetic Serif")

(set-face-attribute 'fixed-pitch nil
                    :family "Aporetic Sans Mono")

(set-face-attribute 'fixed-pitch-serif nil
                    :family "Aporetic Serif Mono")

(dolist (charset '(kana han cjk-misc symbol bopomofo))
  (set-fontset-font t charset (font-spec :family "LXGW WenKai")))

(use-package hl-todo
  :hook (prog-mode . hl-todo-mode))

(use-package doom-modeline
  :config
  (setq doom-modeline-check nil)
  (setq doom-modeline-buffer-encoding nil)
  (setq doom-modeline-always-show-macro-register t)
  (setq doom-modeline-position-column-line-format '(""))
  :init (doom-modeline-mode 1))

(use-package pulsar
  :config
  (dolist (fn '(pulsar-pulse-line-red pulsar-recenter-top pulsar-reveal-entry))
    (add-hook 'minibuffer-setup-hook fn))
  (setq pulsar-delay 0.045
        pulsar-iterations 4
        pulsar-face 'pulsar-green
        pulsar-region-face 'pulsar-yellow
        pulsar-highlight-face 'pulsar-magenta)
  (pulsar-global-mode 1))

(use-package theme-buffet
  :config
  (setq theme-buffet-menu 'end-user)

  (setq theme-buffet-end-user
        '(
          ;; NIGHT: High contrast, deep darks, vibrant accents
          :night
          (modus-vivendi ef-dark ef-winter ef-autumn ef-night ef-duo-dark ef-symbiosis
                         doom-one doom-vibrant doom-dracula doom-palenight doom-tokyo-night)

          ;; MORNING: Crisp, cold lights, high legibility
          :morning
          (modus-operandi ef-light ef-cyprus ef-spring ef-frost ef-duo-light)

          ;; AFTERNOON: Warm lights, tinted backgrounds, soft contrast
          :afternoon
          (modus-operandi-tinted ef-arbutus ef-day ef-kassio ef-summer ef-elea-light ef-maris-light ef-melissa-light ef-trio-light ef-reverie)

          ;; EVENING: Warm darks, lower contrast, cozy/earthy tones
          :evening
          (modus-vivendi-tinted ef-rosa ef-elea-dark ef-maris-dark ef-melissa-dark ef-trio-dark ef-dream
                                doom-gruvbox doom-henna doom-nord doom-snazzy doom-oceanic-next)))

  (theme-buffet-timer-mins 45))

(theme-buffet-a-la-carte)
(after! evil
  (evil-define-key 'normal 'global (kbd "<leader>tt") #'theme-buffet-a-la-carte))

(use-package doom-themes
  :custom
  ;; Global settings (defaults)
  (doom-themes-enable-bold t)   ; if nil, bold is universally disabled
  (doom-themes-enable-italic t) ; if nil, italics is universally disabled
  :config

  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)
  ;; Corrects (and improves) org-mode's native fontification.
 (doom-themes-org-config))

(use-package rainbow-delimiters
  :config
  (add-hook 'prog-mode-hook #'rainbow-delimiters-mode))

(defun fc/next-wallpaper ()
  "Call next wallpaper."
  (interactive)
  (shell-command "noctalia-shell ipc call wallpaper random eDP-1"))

(after! evil
  (evil-global-set-key 'normal (kbd "<leader>tn") #'fc/next-wallpaper))

(use-package nyan-mode
  :after doom-modeline
  :custom
  (nyan-wavy-trail t)
  (nyan-animate-nyancat t)
  (nyan-bar-length 15)
  :config
  (nyan-mode))

(use-package which-key
  :custom
  (which-key-idle-delay 0.5)
  :init
  (which-key-mode))

(use-package lin
  :config
  (setopt lin-face 'lin-blue) ; check doc string for alternative styles
  
  (global-hl-line-mode 1)
  (lin-global-mode 1)

  ;; If you are using the GNOME desktop and want to synchronise the
  ;; `lin-face' with GNOME's accent colour:
  (lin-gnome-accent-color-mode 1))

(use-package evil
  :custom
  (evil-want-keybinding nil)
  :init
  (setq evil-disable-insert-state-bindings t)
  (setq evil-respect-visual-line-mode t)
  (setq evil-want-Y-yank-to-eol t)
  (setq evil-undo-system 'undo-fu)
  (global-visual-line-mode 1)
  :config
  (evil-set-leader '(normal visual) (kbd fc/leader-key))
  (evil-set-leader 'normal (kbd fc/localleader-key) t)
  (evil-mode 1))

(general-define-key :keymaps 'normal "C-e" #'end-of-line)

(use-package evil-collection
  :after evil
  :custom
  (evil-collection-key-blacklist '("SPC"))
  :config
  (delq 'lispy evil-collection-mode-list)
  (evil-collection-init))

(use-package flash
  :vc (:url "https://github.com/Prgebish/flash")
  :commands (flash-jump flash-jump-continue
			            flash-treesitter)
  :custom
  (flash-multi-window t)
  ;; (flash-autojump t)
  (flash-rainbow t)
  :init
  ;; Evil integration (simple setup)
  (after! evil
    (require 'flash-evil)
    (flash-evil-setup t)
    (setq flash-char-jump-labels t))

  (evil-define-key 'normal 'global (kbd "C-s") #'flash-evil-jump)
  (evil-define-key 'visual 'global (kbd "C-s") #'flash-evil-jump)
  (after! evil
    (evil-define-key 'normal 'global [down-mouse-3] 'gt-translate)
    (evil-global-set-key 'normal (kbd "g s") #'avy-goto-line))

  :config
  ;; Search integration (labels during C-s, /, ?)
  (require 'flash-isearch)
  (flash-isearch-mode 1))

(use-package evil-surround
  :config
  (global-evil-surround-mode 1))
(use-package evil-embrace
  :config
  (evil-embrace-enable-evil-surround-integration))
(use-package evil-args
  :after evil
  :config
  (evil-define-key '(operator) evil-inner-text-objects-map "a" 'evil-inner-arg)
  (evil-define-key '(operator) evil-outer-text-objects-map "a" 'evil-outer-arg))

(use-package evil-org
  :after org
  :hook (org-mode . (lambda () evil-org-mode))
  :config
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys))

(use-package evil-escape
  :custom
  (evil-escape-key-sequence "jk")
  :config
  (evil-escape-mode))

(use-package undo-fu)

(use-package evil-exchange
  :config
  (evil-exchange-install))

(use-package evil-multiedit
  :config
  (evil-multiedit-default-keybinds))

(use-package evil-indent-plus
  :config
  (define-key evil-inner-text-objects-map "i" 'evil-indent-plus-i-indent)
  (define-key evil-outer-text-objects-map "i" 'evil-indent-plus-a-indent)
  (define-key evil-inner-text-objects-map "k" 'evil-indent-plus-i-indent-up)
  (define-key evil-outer-text-objects-map "k" 'evil-indent-plus-a-indent-up)
  (define-key evil-inner-text-objects-map "j" 'evil-indent-plus-i-indent-up-down)
  (define-key evil-outer-text-objects-map "j" 'evil-indent-plus-a-indent-up-down))

(use-package evil-lion
  :config
  (evil-lion-mode))

(use-package evil-nerd-commenter
  :config
  (evil-define-text-object evil-a-comment-block (count &optional beg end type)
    (let ((bounds (evilnc-get-comment-bounds)))
      (if bounds
          (evil-range (car bounds) (cdr bounds))
        (user-error "Not inside a comment"))))
  (evil-define-key '(normal visual) 'global "gc" #'evilnc-comment-operator)
  (define-key evil-operator-state-map "gc" 'evil-a-comment-block))

(use-package evil-numbers
  :config
  (define-key evil-normal-state-map (kbd "C-c =") 'evil-numbers/inc-at-pt)
  (define-key evil-normal-state-map (kbd "C-c -") 'evil-numbers/dec-at-pt))

(use-package exato)

(use-package evil-quick-diff
  :vc (:url "https://github.com/rgrinberg/evil-quick-diff")
  :init
  ;; (setq evil-quick-diff-key (kbd "zx"))
  (evil-quick-diff-install))

(use-package evil-goggles
  :config
  (evil-goggles-mode)

  ;; optionally use diff-mode's faces; as a result, deleted text
  ;; will be highlighed with `diff-removed` face which is typically
  ;; some red color (as defined by the color theme)
  ;; other faces such as `diff-added` will be used for other actions
  (evil-goggles-use-diff-faces))

(use-package wgrep)

(use-package lispy
  :hook
  (fennel-mode . lispy-mode)
  (scheme-mode . lispy-mode)
  (emacs-lisp-mode . lispy-mode))

(use-package lispyville
  :after evil
  :init
  (setq lispyville-key-theme
        '((operators normal)
          c-w
          (prettify insert)
          (atom-movement t)
          slurp/barf-lispy
          additional
          additional-insert))
  :hook 
  (lispy-mode . lispyville-mode)
  :config
  (lispyville-set-key-theme)
  (evil-define-key '(normal visual) lispyville-mode-map
    (kbd "M-i") 'lispy-splice)
  (evil-define-key '(normal visual) lispyville-mode-map
    (kbd "M-s") nil))

(use-package projectile
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :custom
  (projectile-project-search-path '("~/Dev/"))
  (projectile-ignored-project-function
   (lambda (project-root)
     (string-prefix-p "/tmp" project-root)))
  :config
  (projectile-mode +1))

(use-package perspective
  :after consult
  :bind
  ("C-x C-b" . persp-list-buffers)
  :custom
  (persp-mode-prefix-key (kbd "C-c w")) 
  :config
  (consult-customize consult-source-buffer :hidden t :default nil)
  (add-to-list 'consult-buffer-sources persp-consult-source)
  :init
  (persp-mode))

(use-package smartparens
  :hook (prog-mode text-mode markdown-mode)
  :config
  (require 'smartparens-config))

(use-package nerd-icons-dired
  :hook
  (dired-mode . nerd-icons-dired-mode))

(use-package diredfl
  :hook
  (dired-mode . hl-line-mode)
  (dired-mode . diredfl-mode))

(use-package dired
  :ensure nil
  :config
  (setq dired-listing-switches
        "-l --almost-all --human-readable --group-directories-first --no-group")
  ;; this command is useful when you want to close the window of `dirvish-side'
  ;; automatically when opening a file
  (put 'dired-find-alternate-file 'disabled nil))

;; (use-package dirvish
;;   :init
;;   (dirvish-override-dired-mode)
;;   :custom
;;   (dirvish-quick-access-entries ; It's a custom option, `setq' won't work
;;    '(("h" "~/"                          "Home")
;;      ("d" "~/Downloads/"                "Downloads")
;;      ("m" "/mnt/"                       "Drives")
;;      ("t" "~/.local/share/Trash/files/" "TrashCan")))
;;   :config
;;   (dirvish-peek-mode)             ; Preview files in minibuffer
;;   (dirvish-side-follow-mode)      ; similar to `treemacs-follow-mode'
;;   (setq dirvish-mode-line-format
;;         '(:left (sort symlink) :right (omit yank index)))
;;   (setq dirvish-attributes           ; The order *MATTERS* for some attributes
;;         '(vc-state subtree-state collapse git-msg file-time file-size)
;;         dirvish-side-attributes
;;         '(vc-state collapse file-size))
;;   ;; open large directory (over 20000 files) asynchronously with `fd' command
;;   (setq dirvish-large-directory-threshold 20000)

;;   ;; BUG can not make it work
;;   ;; setting it after dirvish to ensure `dirvish-mode-map' is loaded
;;   (evil-make-overriding-map dirvish-mode-map 'normal)
;;   :bind ; Bind `dirvish-fd|dirvish-side|dirvish-dwim' as you see fit
;;   (("C-c f" . dirvish)
;;    :map dirvish-mode-map               ; Dirvish inherits `dired-mode-map'
;;    (";"   . dired-up-directory)        ; So you can adjust `dired' bindings here
;;    ("?"   . dirvish-dispatch)          ; [?] a helpful cheatsheet
;;    ("a"   . dirvish-setup-menu)        ; [a]ttributes settings:`t' toggles mtime, `f' toggles fullframe, etc.
;;    ("f"   . dirvish-file-info-menu)    ; [f]ile info
;;    ("o"   . dirvish-quick-access)      ; [o]pen `dirvish-quick-access-entries'
;;    ("s"   . dirvish-quicksort)         ; [s]ort flie list
;;    ("r"   . dirvish-history-jump)      ; [r]ecent visited
;;    ("l"   . dirvish-ls-switches-menu)  ; [l]s command flags
;;    ("v"   . dirvish-vc-menu)           ; [v]ersion control commands
;;    ("*"   . dirvish-mark-menu)
;;    ("y"   . dirvish-yank-menu)
;;    ("N"   . dirvish-narrow)
;;    ("^"   . dirvish-history-last)
;;    ("TAB" . dirvish-subtree-toggle)
;;    ("M-f" . dirvish-history-go-forward)
;;    ("M-b" . dirvish-history-go-backward)
;;    ("M-e" . dirvish-emerge-menu)))

(use-package apheleia
  :config
  (apheleia-global-mode +1))

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
;; TODO remove this after testing
(global-set-key (kbd "<f9>") #'describe-key-briefly)
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

;; TODO https://stackoverflow.com/questions/79894036/org-lint-errors-after-package-updates
(use-package flycheck
  :init
  (global-flycheck-mode +1)
  :custom
  (flycheck-disabled-checkers '(org-lint)))

(use-package lsp-mode
  :init
  ;; set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l")
  (setq lsp-keymap-prefix "C-c l")
  :config
  (setq lsp-disabled-clients '(pyright basedpyright)) ; Disable defaults if they conflict
  (lsp-register-client
   (make-lsp-client :new-connection (lsp-stdio-connection '("ty" "server"))
                    :major-modes '(python-mode python-ts-mode)
                    :server-id 'ty))


  (lsp-register-client
   (make-lsp-client :new-connection (lsp-stdio-connection "nixd")
                    :major-modes '(nix-mode)
                    :priority 0
                    :server-id 'nixd))

  (lsp-register-client
   (make-lsp-client :new-connection (lsp-stdio-connection '("vtsls" "--stdio"))
                    :major-modes '(typescript-mode typescript-ts-mode tsx-ts-mode js-mode js-ts-mode)
                    :priority 1
                    :server-id 'vtsls
                    :language-id (lambda (buffer)
                                   (pcase (buffer-local-value 'major-mode buffer)
                                     ('tsx-ts-mode "typescriptreact")
                                     ((or 'typescript-mode 'typescript-ts-mode) "typescript")
                                     ((or 'js-mode 'js-ts-mode) "javascript")
                                     (_ "typescript")))))


  :hook (;; replace XXX-mode with concrete major-mode(e. g. python-mode)
         (python-ts-mode . lsp-deferred)
         (nix-ts-mode . lsp-deferred)
         (rustic-mode           . lsp-deferred)
         (typescript-ts-mode     . lsp-deferred)
         (tsx-ts-mode     . lsp-deferred)
         (js-ts-mode             . lsp-deferred)
         (astro-ts-mode             . lsp-deferred)
         (c-mode         . lsp-deferred)
         ;; if you want which-key integration
         (lsp-mode . lsp-enable-which-key-integration))
  :commands (lsp lsp-deferred))


(use-package lsp-ui :commands lsp-ui-mode)
(use-package consult-lsp)


(evil-define-key 'motion 'global
  "K"   #'lsp-describe-thing-at-point   ; Hover doc
  "gd"  #'lsp-find-definition           ; Go to definition
  "gD"  #'lsp-find-declaration          ; Go to declaration
  "gI"  #'lsp-find-implementation       ; Go to implementation
  "gy"  #'lsp-find-type-definition      ; Go to type definition
  "gO"  #'consult-lsp-file-symbols      ; Go to file symbols
  "grn" #'lsp-rename                    ; Rename symbol
  "gra" #'lsp-execute-code-action       ; Code actions
  "grr" #'lsp-find-references           ; Find references
  )

(use-package treesit
  :ensure nil
  :config
  (setq treesit-language-source-alist
        '((bash "https://github.com/tree-sitter/tree-sitter-bash")))
  (setq major-mode-remap-alist
        '((bash-mode . bash-ts-mode))))


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

(use-package transient)
(use-package magit
  :config
  (add-hook 'magit-process-find-password-functions 'magit-process-password-auth-source)
  :custom
  (magit-display-buffer-function #'magit-display-buffer-fullframe-status-v1)
  :hook
  (git-commit-mode . evil-insert-state)
  :defer t)

(fc/map 'normal "gg" #'magit)

(defun fc/diff-hl-update-colors (&rest _)
  "Dynamically apply the current theme's standard diff colors to diff-hl faces.
   Sets both background and foreground to create a solid fringe block."
  (let ((added   (face-attribute 'diff-added :foreground nil 'default))
        (changed (face-attribute 'diff-changed :foreground nil 'default))
        (removed (face-attribute 'diff-removed :foreground nil 'default)))
    (custom-set-faces
     ;; Added lines: Inherit current theme's 'Added' color
     `(diff-hl-insert ((t (:inherit diff-added :background ,added :foreground ,added))))
     ;; Changed lines: Inherit current theme's 'Changed' color
     `(diff-hl-change ((t (:inherit diff-changed :background ,changed :foreground ,changed))))
     ;; Deleted lines: Inherit current theme's 'Removed' color
     `(diff-hl-delete ((t (:inherit diff-removed :background ,removed :foreground ,removed)))))))

(add-hook 'enable-theme-functions #'fc/diff-hl-update-colors)

(fc/diff-hl-update-colors)

(use-package diff-hl
  :init
  (global-diff-hl-mode)
  :config
  (add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh))

(use-package forge
  :after magit
  :custom
  (forge-add-default-bindings nil))

(use-package browse-at-remote
  :config
  (fc/map 'normal "gb" #'browse-at-remote))

(use-package git-timemachine
  :after transient
  :config
  (fc/map 'normal "gt" #'git-timemachine))

(use-package git-modes)

(defun fc/consult-books ()
  "Consult books in the ~/Documents/books/ folder."
  (interactive)
  (consult-fd (expand-file-name "~/Documents/books")))

(use-package consult
  ;; Replace bindings. Lazily loaded by `use-package'.
  :bind (;; C-c bindings in `mode-specific-map'
         ("C-c M-x" . consult-mode-command)
         ("C-c h" . consult-history)
         ("C-c k" . consult-kmacro)
         ("C-c i" . consult-info)
         ([remap Info-search] . consult-info)
         ;; C-x bindings in `ctl-x-map'
         ("C-x M-:" . consult-complex-command)     ;; orig. repeat-complex-command
         ("C-x b" . consult-buffer)                ;; orig. switch-to-buffer
         ("C-x 4 b" . consult-buffer-other-window) ;; orig. switch-to-buffer-other-window
         ("C-x 5 b" . consult-buffer-other-frame)  ;; orig. switch-to-buffer-other-frame
         ("C-x t b" . consult-buffer-other-tab)    ;; orig. switch-to-buffer-other-tab
         ("C-x r b" . consult-bookmark)            ;; orig. bookmark-jump
         ("C-x p b" . consult-project-buffer)      ;; orig. project-switch-to-buffer
         ;; Custom M-# bindings for fast register access
         ("M-#" . consult-register-load)
         ("M-'" . consult-register-store)          ;; orig. abbrev-prefix-mark (unrelated)
         ("C-M-#" . consult-register)
         ;; Other custom bindings
         ("M-y" . consult-yank-pop)                ;; orig. yank-pop
         ;; M-g bindings in `goto-map'
         ("M-g e" . consult-compile-error)
         ("M-g r" . consult-grep-match)
         ("M-g f" . consult-flymake)               ;; Alternative: consult-flycheck
         ("M-g g" . consult-goto-line)             ;; orig. goto-line
         ("M-g M-g" . consult-goto-line)           ;; orig. goto-line
         ("M-g m" . consult-mark)
         ("M-g k" . consult-global-mark)
         ("M-g i" . consult-imenu)
         ("M-g I" . consult-imenu-multi)
         ;; M-s bindings in `search-map'
         ("M-s d" . consult-fd)                  ;; Alternative: consult-fd
         ("M-s c" . consult-locate)
         ("M-s g" . consult-grep)
         ("M-s G" . consult-git-grep)
         ("M-s r" . consult-ripgrep)
         ("M-s l" . consult-line)
         ("M-s L" . consult-line-multi)
         ("M-s m" . consult-man)
         ("M-s s" . consult-outline)
         ("M-s b" . fc/consult-books)
         ("M-s k" . consult-keep-lines)
         ("M-s u" . consult-focus-lines)
         ;; Isearch integration
         ("M-s e" . consult-isearch-history)
         :map isearch-mode-map
         ("M-e" . consult-isearch-history)         ;; orig. isearch-edit-string
         ("M-s e" . consult-isearch-history)       ;; orig. isearch-edit-string
         ("M-s l" . consult-line)                  ;; needed by consult-line to detect isearch
         ("M-s L" . consult-line-multi)            ;; needed by consult-line to detect isearch
         ;; Minibuffer history
         :map minibuffer-local-map
         ("M-s" . consult-history)                 ;; orig. next-matching-history-element
         ("M-r" . consult-history))                ;; orig. previous-matching-history-element

  :custom
  (consult-async-min-input 2)
  (consult-fd-args '("fd" "--full-path --color=never -E node_modules -H -E .git"))
  ;; The :init configuration is always executed (Not lazy)
  :init

  ;; Tweak the register preview for `consult-register-load',
  ;; `consult-register-store' and the built-in commands.  This improves the
  ;; register formatting, adds thin separator lines, register sorting and hides
  ;; the window mode line.
  (advice-add #'register-preview :override #'consult-register-window)
  (setq register-preview-delay 0.5)

  ;; Use Consult to select xref locations with preview
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)

  ;; Configure other variables and modes in the :config section,
  ;; after lazily loading the package.
  :config

  ;; Optionally configure preview. The default value
  ;; is 'any, such that any key triggers the preview.
  ;; (setq consult-preview-key 'any)
  ;; (setq consult-preview-key "M-.")
  ;; (setq consult-preview-key '("S-<down>" "S-<up>"))
  ;; For some commands and buffer sources it is useful to configure the
  ;; :preview-key on a per-command basis using the `consult-customize' macro.
  (consult-customize
   consult-theme :preview-key '(:debounce 0.2 any)
   consult-ripgrep consult-git-grep consult-grep consult-man
   consult-bookmark consult-recent-file consult-xref
   consult-source-bookmark consult-source-file-register
   consult-source-recent-file consult-source-project-recent-file
   ;; :preview-key "M-."
   :preview-key '(:debounce 0.4 any))

  ;; Optionally configure the narrowing key.
  ;; Both < and C-+ work reasonably well.
  (setq consult-narrow-key "<") ;; "C-+"

  ;; Optionally make narrowing help available in the minibuffer.
  ;; You may want to use `embark-prefix-help-command' or which-key instead.
  ;; (keymap-set consult-narrow-map (concat consult-narrow-key " ?") #'consult-narrow-help)
  )
(fc/map 'normal
  "f" #'consult-ripgrep
  "SPC" #'consult-fd)

(use-package consult-emms
  :after consult
  :vc (:url "https://github.com/Hugo-Heagren/consult-emms"))

(use-package helpful)
(evil-define-key '(insert normal) 'global
    (kbd "C-h f") #'helpful-callable
    (kbd "C-c C-d") #'helpful-at-point
    (kbd "C-h F") #'helpful-function
    (kbd "C-h v") #'helpful-variable
    (kbd "C-h k") #'helpful-key
    (kbd "C-h x") #'helpful-command)
(use-package elisp-demos
  :after helpful
  :config
  (advice-add 'helpful-update :after #'elisp-demos-advice-helpful-update))

;; Enable Vertico.
(use-package vertico
  :custom
  ;; (vertico-scroll-margin 0) ;; Different scroll margin
  ;; (vertico-count 20) ;; Show more candidates
  ;; (vertico-resize t) ;; Grow and shrink the Vertico minibuffer
  (vertico-cycle t) ;; Enable cycling for `vertico-next/previous'
  :init
  (vertico-mode))

;; Persist history over Emacs restarts. Vertico sorts by history position.
(use-package savehist
  :ensure nil
  :init
  (savehist-mode))

;; Emacs minibuffer configurations.
(use-package emacs
  :ensure nil
  :custom
  ;; Enable context menu. `vertico-multiform-mode' adds a menu in the minibuffer
  ;; to switch display modes.
  (context-menu-mode t)
  ;; Support opening new minibuffers from inside existing minibuffers.
  (enable-recursive-minibuffers t)
  ;; Hide commands in M-x which do not work in the current mode.  Vertico
  ;; commands are hidden in normal buffers. This setting is useful beyond
  ;; Vertico.
  (read-extended-command-predicate #'command-completion-default-include-p)
  ;; Do not allow the cursor in the minibuffer prompt
  (minibuffer-prompt-properties
   '(read-only t cursor-intangible t face minibuffer-prompt)))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles partial-completion))))
  (completion-pcm-leading-wildcard t)) ;; Emacs 31: partial-completion behaves like substring

;; Enable rich annotations using the Marginalia package
(use-package marginalia
  ;; Bind `marginalia-cycle' locally in the minibuffer.  To make the binding
  ;; available in the *Completions* buffer, add it to the
  ;; `completion-list-mode-map'.
  :bind (:map minibuffer-local-map
              ("M-A" . marginalia-cycle))

  ;; The :init section is always executed.
  :init

  ;; Marginalia must be activated in the :init section of use-package such that
  ;; the mode gets enabled right away. Note that this forces loading the
  ;; package.
  (marginalia-mode))

(use-package embark
  :bind
  (("C-." . embark-act)         ;; pick some comfortable binding
   ("C-;" . embark-dwim)        ;; good alternative: M-.
   ("C-h B" . embark-bindings)) ;; alternative for `describe-bindings'

  :init

  ;; Optionally replace the key help with a completing-read interface
  (setq prefix-help-command #'embark-prefix-help-command)

  ;; Show the Embark target at point via Eldoc. You may adjust the
  ;; Eldoc strategy, if you want to see the documentation from
  ;; multiple providers. Beware that using this can be a little
  ;; jarring since the message shown in the minibuffer can be more
  ;; than one line, causing the modeline to move up and down:

  ;; (add-hook 'eldoc-documentation-functions #'embark-eldoc-first-target)
  ;; (setq eldoc-documentation-strategy #'eldoc-documentation-compose-eagerly)

  ;; Add Embark to the mouse context menu. Also enable `context-menu-mode'.
  ;; (context-menu-mode 1)
  ;; (add-hook 'context-menu-functions #'embark-context-menu 100)

  :config
  ;; Hide the mode line of the Embark live/completions buffers
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))
(fc/map 'normal vertico-map
      "C-c C-e" #'embark-export
      "C-c C-o" #'embark-collect
      "C-c C-l" #'embark-live)
(use-package embark-consult
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

(use-package gt
  :commands (gt-translate)
  :config
  (setq gt-langs '(en zh))
  (setq gt-default-translator
        (gt-translator :engines (gt-stardict-engine
                                 :dir "~/.stardict/dic"
                                 :exact nil))))

(fc/map 'normal "l" 'gt-translate)

(use-package casual
  ;; :config
  ;; (fc/map 'normal Info-mode-map
  ;;   "?" #'casual-info-tmenu)
  ;; (fc/map 'normal dired-mode-map
  ;;   "?" #'casual-dired-tmenu)
  )

(use-package vterm
  :ensure nil)

(use-package tracking)

(use-package telega
  :ensure nil
  :commands telega
  :config
  (setq telega-use-tracking-for '(or unmuted mention)
        telega-completing-read-function #'completing-read
        telega-msg-rainbow-title t
        telega-chat-fill-column 75)

  ;; Show notifications in the mode line
  (add-hook 'telega-load-hook #'telega-mode-line-hook)

  ;; Disable chat buffer auto-fill
  (add-hook 'telega-chat-mode-hook #'telega-chat-auto-fill-mode))

(use-package eat
  :ensure nil)

;; (use-package bluetooth)
;; (use-package nm
;;   :vc (:url "https://github.com/Kodkollektivet/emacs-nm"))

(use-package direnv
  :config
  (direnv-mode))

(use-package emms
  :after evil
  :commands emms
  :custom
  (emms-mode-line-format nil)
  (emms-player-list '(emms-player-mpv))
  (emms-lyrics-display-on-modeline nil)
  :config
  (emms-all)
  (repeat-mode)
  (emms-add-directory-tree "~/Music/")
  (emms-shuffle)
  (emms-mode-line-mode -1)
  ;; Volume commands in repeat mode
  (dolist (elm '(emms-volume-raise
                 emms-volume-lower
		         emms-pause
                 emms-next
                 emms-previous))
    (put elm 'repeat-map 'emms-volume-repeat-map))

  (defvar emms-volume-repeat-map
    (let ((map (make-sparse-keymap)))
      (define-key map "=" #'emms-volume-raise)
      (define-key map "-" #'emms-volume-lower)
      (define-key map (kbd "SPC") #'emms-pause)
      (define-key map "n" #'emms-next)
      (define-key map "p" #'emms-previous)
      map)
    "Keymap for continuous volume adjustment in EMMS")

  (general-define-key
    "C-c m SPC" #'emms-pause
    "C-c m p" #'emms-previous
    "C-c m n" #'emms-next
    "C-c m s" #'emms-stop
    "C-c m m" #'emms
    "C-c m =" #'emms-volume-raise
    "C-c m -" #'emms-volume-lower)

  (setq emms-volume-change-function 'emms-volume-pulse-change)

  (evil-define-key 'normal emms-playlist-mode-map
    "q" #'emms-playlist-mode-bury-buffer))

(use-package reader
  :ensure nil
  :hook (reader-mode . (lambda () (hl-line-mode 0))))

(use-package nov
  :config
  (add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode)))

(use-package devdocs
  :config
  (add-hook 'rust-mode-hook
            (lambda () (setq-local devdocs-current-docs '("rust"))))

  (add-hook 'python-ts-mode-hook
            (lambda () (setq-local devdocs-current-docs '("python~3.14"))))

  (add-hook 'emacs-lisp-mode-hook
            (lambda () (setq-local devdocs-current-docs '("elisp")))))

(use-package rime
  :ensure nil
  :custom
  (default-input-method "rime")
  :config
  (setq
   ;; rime-emacs-module-header-root (concat (shell-command-to-string "nix eval --raw nixpkgs#emacs-pgtk") "/include")
   ;; rime-librime-root (shell-command-to-string "nix eval --raw nixpkgs#librime")
   rime-user-data-dir "~/.local/share/fcitx5/rime/")
  ;; rime-share-data-dir (concat (shell-command-to-string "nix eval --raw nixpkgs#rime-data") "/share/rime-data")
  )

(use-package dwim-shell-command
  :custom
  (dwim-shell-commands-git-clone-dirs '("~/dev" "~/Downloads"))
  :bind (([remap shell-command] . dwim-shell-command)
         :map dired-mode-map
         ([remap dired-do-async-shell-command] . dwim-shell-command)
         ([remap dired-do-shell-command] . dwim-shell-command)
         ([remap dired-smart-shell-command] . dwim-shell-command))
  :config
  (require 'dwim-shell-commands))

(use-package guix
  :ensure nil
  :config
  (fc/map 'normal "gi" #'guix))

;; (use-package eee
;;   :vc (:url "https://github.com/eval-exec/eee.el")
;;   :config
;;   ;; Issues and pull requests are welcome
;;   (setq ee-terminal-command "alacritty")

;;   ;; (global-definer "f" 'ee-find)
;;   ;; (global-definer "g" 'ee-lazygit)
;;   ;; (global-definer "y" 'ee-yazi-project)
;;   ;; (general-def "C-x C-f" 'ee-yazi)
;;   ;; (general-def "C-S-f" 'ee-rg)
;;   ;; (general-evil-define-key 'normal 'global "M-f" 'ee-line)
;;   )

(use-package gptel
  :bind
  (("C-c a p" . gptel)
   ("C-c a m" . gptel-menu))
  :config
  (gptel-make-openai "opencode"
    :host "opencode.ai"
    :endpoint "/zen/v1/chat/completions"            
    :stream t                                      
    ;; :key #'gptel-api-key-from-auth-source         
    :models '((minimax-m2.5-free
               :description "minimax"
               :capabilities (tool-use json)
               :context-window 200
               :input-cost 0.0
               :output-cost 0.0)
		      (big-pickle
               :description "Big Pickle model"
               :capabilities (tool-use json)
               :context-window 200
               :input-cost 0.0
               :output-cost 0.0)))
  (setq gptel-backend
        (gptel-make-openai "bl"
          :host "dashscope.aliyuncs.com"
          :endpoint "/compatible-mode/v1/chat/completions"            
          :stream t                                      
          :key (auth-source-pick-first-password :host "api.aliyuncs.com")
          :models '((qwen3.5-flash
                     :description "qwen3.5-flash"
                     :capabilities (tool-use json)
                     :context-window 200
                     :input-cost 0.0
                     :output-cost 0.0)
                    (kimi-k2.5
                     :description "kimi-k2.5"
                     :capabilities (tool-use json)
                     :context-window 200
                     :input-cost 0.0
                     :output-cost 0.0)
                    (qwen3.5-plus
                     :description "qwen3.5-plus"
                     :capabilities (tool-use json)
                     :context-window 200
                     :input-cost 0.0
                     :output-cost 0.0)
                    (MiniMax-M25
                     :description "MiniMax-M2.5"
                     :capabilities (tool-use json)
                     :context-window 200
                     :input-cost 0.0
                     :output-cost 0.0))))
  (setq gptel-default-mode #'org-mode)
  (setq gptel-model 'qwen3-flash))

;; TODO use this in melpa
;; (use-package acp
;;   :ensure t
;;   :vc (:url "https://github.com/xenodium/acp.el"))

(use-package agent-shell
  :custom
  ;; BUG https://github.com/niri-wm/niri/issues/2664
  (agent-shell-screenshot-command '("niri" "msg" "action" "screenshot" "--path"))
  (agent-shell-opencode-default-model-id "alibaba-cn/qwen3.5-plus")
  :config
  ;; Evil state-specific RET behavior: insert mode = newline, normal mode = send
  (general-define-key
   :keymaps 'agent-shell-mode-map
   :states 'insert
   "RET" #'newline
   "TAB" nil
   :states 'normal
   "RET" #'comint-send-input
   "TAB" nil)

  
  ;; Configure *agent-shell-diff* buffers to start in Emacs state
  (add-hook 'diff-mode-hook
	        (lambda ()
	          (when (string-match-p "\\*agent-shell-diff\\*" (buffer-name))
		        (evil-emacs-state)))))

(general-define-key "C-c a s" #'agent-shell)

(setq auth-sources '("~/.authinfo.gpg")
      user-full-name "zhafacai"
      user-mail-address "zhafacai@gmail.com")

(use-package notmuch
  :ensure nil
  :bind
  ("C-c e" . notmuch)
  :config
  (setq notmuch-identities '("zfc <zhafacai@gmail.com>"))
  (setq notmuch-fcc-dirs
        '(("zhafacai@gmail.com" . "gmail/Sent")))
  (setq notmuch-show-logo nil
        notmuch-column-control 1.0
        notmuch-hello-auto-refresh t
        notmuch-hello-recent-searches-max 20
        notmuch-hello-thousands-separator ""
        notmuch-hello-sections '(notmuch-hello-insert-saved-searches)
        notmuch-show-all-tags-list t)

  (setq notmuch-search-oldest-first nil)

  (setq notmuch-saved-searches
        `(( :name "📥 inbox"
            :query "tag:inbox"
            :sort-order newest-first
            :key ,(kbd "i"))
          ( :name "💬 all unread (inbox)"
            :query "tag:unread and tag:inbox"
            :sort-order newest-first
            :key ,(kbd "u"))
          ( :name "🛠️ unread packages"
            :query "tag:unread and tag:package"
            :sort-order newest-first
            :key ,(kbd "p"))
          ( :name "🏆 unread coaching"
            :query "tag:unread and tag:coach"
            :sort-order newest-first
            :key ,(kbd "c")))))


(setq browse-url-browser-function 'browse-url-generic
      browse-url-generic-program "librewolf")

(use-package pinentry
  :demand t
  :config
  (pinentry-start))

(use-package org
  :ensure nil
  :custom
  ;; org-default-notes-file (concat org-directory "notes.org")
  ;; org-clock-in-switch-to-state "DOING"
  ;; org-clock-out-when-done '("DONE" "CANCEL" "WAIT")
  ;; org-agenda-files `(,org-default-notes-file)
  ;; org-agenda-start-with-log-mode t
  (org-M-RET-may-split-line '((default . nil)))
  (org-insert-heading-respect-content t)
  (org-log-done 'time)
  (org-log-into-drawer t)
  (org-tags-column -100)
  (org-todo-keywords
   '((sequence "TODO(t)" "NEXT(n)" "WAIT(w@/!)" "|" "DONE(d!)" "CNCL(c@)")))
  (org-todo-keyword-faces
   '(("TODO"   . org-todo)
     ("NEXT"   . +org-todo-active)
     ("WAIT"   . +org-todo-onhold)
     ("DONE"   . org-done)
     ("CNCL" . +org-todo-cancel)))
  (org-tag-alist
   '(("@work" . ?w)
     ("@life" . ?l)))
  (org-agenda-window-setup 'only-window)
  (org-directory (file-truename "~/share/notes/eorg/"))
  (org-agenda-restore-windows-after-quit t)
  (org-startup-with-inline-images t)
  (org-startup-indented t)
  (org-src-preserve-indentation nil)
  (org-edit-src-content-indentation 0))
;; :config
;; (advice-add 'org-agenda-todo :after (lambda (&rest _) (org-save-all-org-buffers))))
(use-package mixed-pitch
  :hook
  (org-mode . mixed-pitch-mode))

(use-package org-tree-slide
  :after evil
  :config
  (fc/map :keymaps 'org-tree-slide-mode-map
    "j" #'org-tree-slide-move-next-tree
    "k" #'org-tree-slide-move-previous-tree))

(use-package valign
  :hook
  (org-mode . valign-mode))

;; (after! org
;;   (add-to-list 'org-modules 'org-habit t)
;;   (add-to-list 'org-modules 'ol-info t)
;;   (setq org-habit-show-habits t
;;         org-habit-show-all-today nil))

;; (after! modus-themes
;;   (defun fc/apply-org-habit-faces ()
;;     "Apply org-habit faces using Modus/Ef palette."
;;     (when custom-enabled-themes
;;       (modus-themes-with-colors
;; 	(custom-set-faces
;;          `(org-habit-clear-face
;;            ((t (:background ,bg-dim :foreground ,green-warmer))))
;;          `(org-habit-ready-face
;;            ((t (:background ,bg-active :foreground ,blue))))
;;          `(org-habit-alert-face
;;            ((t (:background ,bg-yellow-subtle :foreground ,yellow))))
;;          `(org-habit-overdue-face
;;            ((t (:background ,bg-red-subtle :foreground ,red))))))))

;;   (add-hook 'doom-load-theme-hook #'fc/apply-org-habit-faces))

(use-package org-modern
  :custom
  (org-modern-hide-stars nil)
  (org-modern-star '("◉" "○" "◈" "◇"))
  (org-modern-block-name nil)
  :hook
  (org-mode . org-modern-mode)
  (org-agenda-finalize . org-modern-agenda))

(use-package org-appear
  :hook
  (org-mode . org-appear-mode))

(use-package org-modern-indent
  :vc (:url "https://github.com/jdtsmith/org-modern-indent")
  :config
  (add-hook 'org-mode-hook #'org-modern-indent-mode 90))

(use-package org-contrib
  :init
  (setq org-eldoc-breadcrumb-separator " → ")
  :hook (org-mode . org-eldoc-load))
(setq eldoc-documentation-strategy #'eldoc-documentation-compose-eagerly)

(use-package denote
  :hook
  ((text-mode . denote-fontify-links-mode-maybe)
   (dired-mode . denote-dired-mode))
  :bind
  (("C-c n n" . denote)
   ("C-c n d" . denote-dired)
   ("C-c n l" . denote-link)
   ("C-c n L" . denote-add-links)
   ("C-c n b" . denote-backlinks)
   ("C-c n q c" . denote-query-contents-link)
   ("C-c n q f" . denote-query-filenames-link)
   ("C-c n r" . denote-rename-file)
   ("C-c n R" . denote-rename-file-using-front-matter)
   :map dired-mode-map
   ("C-c C-d C-i" . denote-dired-link-marked-notes)
   ("C-c C-d C-r" . denote-dired-rename-files)
   ("C-c C-d C-k" . denote-dired-rename-marked-files-with-keywords)
   ("C-c C-d C-R" . denote-dired-rename-marked-files-using-front-matter))
  :config
  (setq denote-directory (concat org-directory "denote"))
  (setq denote-save-buffers nil)
  (setq denote-known-keywords '("emacs" "linux" "hack" "trade"))
  (setq denote-infer-keywords t)
  (setq denote-sort-keywords t)
  (setq denote-prompts '(title keywords))
  (setq denote-excluded-directories-regexp nil)
  (setq denote-keywords-to-not-infer-regexp nil)
  (setq denote-rename-confirmations '(rewrite-front-matter modify-file-name))
  (setq denote-date-prompt-use-org-read-date t)
  (denote-rename-buffer-mode 1))

(use-package denote-org
  :after denote
  :bind (:map org-mode-map
              ("C-c n o e" . denote-org-extract-org-subtree)
              ("C-c n o h" . denote-org-link-to-heading)
              ("C-c n o H" . denote-org-backlinks-for-heading)
              ("C-c n o f" . denote-org-convert-links-to-file-type)
              ("C-c n o d" . denote-org-convert-links-to-denote-type)
              ("C-c n o i" . denote-org-dblock-insert-files)
              ("C-c n o l" . denote-org-dblock-insert-links)
              ("C-c n o b" . denote-org-dblock-insert-backlinks)
              ("C-c n o m" . denote-org-dblock-insert-missing-links)
              ("C-c n o a" . denote-org-dblock-insert-files-as-headings)))

(use-package denote-journal
  :bind
  ("C-c n j" . denote-journal-new-or-existing-entry)
  :hook (calendar-mode . denote-journal-calendar-mode)
  :config
  ;; Use the "journal" subdirectory of the `denote-directory'.  Set this
  ;; to nil to use the `denote-directory' instead.
  (setq denote-journal-directory
        (expand-file-name "journal" denote-directory))
  ;; Default keyword for new journal entries. It can also be a list of
  ;; strings.
  (setq denote-journal-keyword "journal")
  ;; Read the doc string of `denote-journal-title-format'.
  (setq denote-journal-title-format 'day-date-month-year))

(use-package denote-sequence
  :after denote
  :bind (("C-c n s s" . denote-sequence)
         ("C-c n s f" . denote-sequence-find)
         ("C-c n s l" . denote-sequence-link)
         ("C-c n s d" . denote-sequence-dired)
         ("C-c n s r" . denote-sequence-reparent)
         ("C-c n s c" . denote-sequence-convert)))

(use-package consult-denote
  :bind (("C-c n f" . consult-denote-find)
         ("C-c n g" . consult-denote-grep))
  :config
  (consult-denote-mode 1))

(use-package org-gtd
  :after (org transient)
  :demand t
  :init
  ;; Suppress upgrade warnings (must be set before package loads)
  (setq org-gtd-update-ack "4.0.0")
  ;; Set GTD directory before package loads
  (setq org-gtd-directory (concat org-directory "gtd"))

  :custom
  (org-gtd-keyword-mapping '((todo . "TODO")
                             (next . "NEXT")
                             (wait . "WAIT")
                             (done . "DONE")
                             (canceled . "CNCL")))
  ;; Enable per-type refile prompting (recommended)
  ;; Without this, all items auto-refile to first target without prompting
  (org-gtd-refile-to-any-target nil)
  (org-gtd-save-after-organize t)

  :config
  (org-edna-mode)
  ;; Add org-gtd files to your agenda (in :config so org-gtd-directory is defined)
  (setq org-agenda-files (list org-gtd-directory))
  :bind
  ;; Global keybindings (work anywhere in Emacs)
  (("C-c d c" . org-gtd-capture)
   ("C-c d e" . org-gtd-engage)
   ("C-c d p" . org-gtd-process-inbox)
   ("C-c d n" . org-gtd-show-all-next)
   ("C-c d s" . org-gtd-reflect-stuck-projects)

   ;; Keybinding for organizing items (only works in clarify buffers)
   :map org-gtd-clarify-mode-map
   ("C-c c" . org-gtd-organize)

   ;; Quick actions on tasks in agenda views (optional but recommended)
   :map org-agenda-mode-map
   ("C-c ." . org-gtd-agenda-transient)))

(defun fc/org-insert-link-dwim ()
  "Like `org-insert-link' but with personal dwim preferences."
  (interactive)
  (let* ((point-in-link (org-in-regexp org-link-any-re 1))
         (clipboard-url (when (string-match-p "^http" (current-kill 0))
                          (current-kill 0)))
         (region-content (when (region-active-p)
                           (buffer-substring-no-properties (region-beginning)
                                                           (region-end)))))
    (cond ((and region-content clipboard-url (not point-in-link))
           (delete-region (region-beginning) (region-end))
           (insert (org-make-link-string clipboard-url region-content)))
          ((and clipboard-url (not point-in-link))
           (insert (org-make-link-string
                    clipboard-url
                    (read-string "title: "
                                 (with-current-buffer (url-retrieve-synchronously clipboard-url)
                                   (dom-text (car
                                              (dom-by-tag (libxml-parse-html-region
                                                           (point-min)
                                                           (point-max))
                                                          'title))))))))
          (t
           (call-interactively 'org-insert-link)))))

(with-eval-after-load 'org
  (evil-define-key 'normal org-mode-map
    (kbd "C-c C-l") #'fc/org-insert-link-dwim))

(use-package uiua-mode
  :mode "\\.ua\\'")

(use-package sol-mode
  :mode "\\.sol\\'")

(with-eval-after-load 'treesit
  (add-to-list 'treesit-language-source-alist 
               '(solidity "https://github.com/JoranHonig/tree-sitter-solidity")))

(with-eval-after-load 'treesit
  (add-to-list 'treesit-language-source-alist 
               '(cpp "https://github.com/tree-sitter/tree-sitter-cpp"))
  (add-to-list 'treesit-language-source-alist 
               '(c "https://github.com/tree-sitter/tree-sitter-c"))
  (add-to-list 'treesit-language-source-alist 
               '(cmake "https://github.com/uyha/tree-sitter-cmake")))

;; NOTE https://github.com/liblit/demangle-mode this one might be helpful
(add-to-list 'major-mode-remap-alist
             '(c++-mode . c++-ts-mode))
(add-to-list 'major-mode-remap-alist
             '(c-mode . c-ts-mode))
(use-package disaster
  :commands (disaster)
  :init
  (setq disaster-assembly-mode #'nasm-mde))
;; TODO use map like this
;; (map! :localleader
;;       :map (c++-mode-map c-mode-map)
;;       :desc "Disaster" "d" #'disaster))
(use-package cmake-mode)

(with-eval-after-load 'treesit
  (add-to-list 'treesit-language-source-alist 
               '(python "https://github.com/tree-sitter/tree-sitter-python")))

(add-to-list 'major-mode-remap-alist
             '(python-mode . python-ts-mode))
(use-package uv-mode
  :hook (python-ts-mode . uv-mode-auto-activate-hook))

(with-eval-after-load 'treesit
  (add-to-list 'treesit-language-source-alist 
               '(rust "https://github.com/tree-sitter/tree-sitter-rust")))

(add-to-list 'major-mode-remap-alist
             '(rust-mode . rustic-mode))
(use-package rust-mode
  :custom
  (rust-mode-treesitter-derive t))
(use-package rustic
  :custom
  ;; (rustic-lsp-client 'eglot)
  (rustic-format-on-save t))

(with-eval-after-load 'treesit
  (add-to-list 'treesit-language-source-alist 
               '(css "https://github.com/tree-sitter/tree-sitter-css"))
  (add-to-list 'treesit-language-source-alist 
               '(json "https://github.com/tree-sitter/tree-sitter-json"))
  (add-to-list 'treesit-language-source-alist 
               '(typescript "https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src"))
  (add-to-list 'treesit-language-source-alist 
               '(tsx "https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src"))
  (add-to-list 'treesit-language-source-alist 
               '(javascript "https://github.com/tree-sitter/tree-sitter-javascript" "master" "src")))

(add-to-list 'auto-mode-alist '("\\.tsx\\'" . tsx-ts-mode))
(add-to-list 'major-mode-remap-alist
             '(json-mode . json-ts-mode))
(add-to-list 'major-mode-remap-alist
             '(css-mode . css-ts-mode))
(add-to-list 'major-mode-remap-alist
             '(typescript-mode . typescript-ts-mode))
(add-to-list 'major-mode-remap-alist
             '(js-mode . js-ts-mode))

(use-package lsp-tailwindcss
  :init
  (setq lsp-tailwindcss-add-on-mode t)
  :after lsp-mode)

(use-package fennel-mode
  :mode "\\.fnl\\'")

(use-package kdl-mode)

(use-package nix-ts-mode
 :mode "\\.nix\\'")

(after! treesit
  (add-to-list 'treesit-language-source-alist 
               '(nix "https://github.com/nix-community/tree-sitter-nix")))

(after! treesit
  (add-to-list 'treesit-language-source-alist 
               '(astro "https://github.com/virchau13/tree-sitter-astro")))
(use-package astro-ts-mode
  :mode "\\.astro\\'")

(use-package json-mode)

(setq ewm-input-config
      '((touchpad :natural-scroll t :tap t :dwt t)
        (mouse :accel-profile "flat")
        (trackpoint :accel-speed 0.5)
        (keyboard :repeat-delay 200 :repeat-rate 25
                  :xkb-layouts "us"
                  :xkb-options "ctrl:nocaps,grp:alt_shift_toggle")))
(setq ewm-output-config
      '(("eDP-1" :width 2560 :height 1440 :scale 1.8)))

(defun fc/persp-select-by-index (index)
  "Switch perspective based on the INDEX."
  (let* ((target-persp (cond
                        ((eq index 1) "main")
                        ((eq index 2) "browser")
                        ((eq index 3) "terminal")
                        (t (format "PER-%d" index)))))
    (persp-switch target-persp)))

(use-package ewm
  :ensure nil
  :bind (:map ewm-mode-map
              ("s-0" . ewm-launch-app)
              ("s-w" . (lambda ()
                         (interactive)
                         (start-process "ghostty" nil "nixGLIntel" "ghostty"))))
  :config
  ;; (add-to-list 'ewm-intercept-prefixes ?\C-c)   
  ;; (add-to-list 'ewm-intercept-prefixes ?\M-&)   
  (dotimes (i 9)
    (let ((n (1+ i)))
      (define-key ewm-mode-map
                  (kbd (format "s-%d" n))
                  (lambda ()
                    (interactive)
                    (fc/persp-select-by-index n))))))

(add-hook 'emacs-startup-hook
          (lambda ()
            (start-process "noctalia" nil "noctalia-shell")))


(tab-bar-mode -1)
(setq tab-bar-show nil)


;; TODO switch to glide-browser once https://github.com/NixOS/nixpkgs/pull/447604 is merged
(use-package qutebrowser
  :vc (                                 ;; use fork
       :url "https://github.com/sarg/qutebrowser.el"
       :rev "optional-exwm"))
