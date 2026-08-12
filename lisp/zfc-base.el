(use-package emacs
  :ensure nil
  :bind                                              ; NOTE: M-x describe-personal-bindings (for all use-packge binds)
  (
   ;; ("M-o" . other-window)
   ("C-x C-z" . nil)
   ([remap capitalize-word] . capitalize-dwim)       ; Make M-c work on regions
   ([remap downcase-word] . downcase-dwim)           ; Make M-l work on regions
   ([remap upcase-word] . upcase-dwim)               ; Make M-u work on regions
   ([remap kill-buffer] . kill-current-buffer)       ; C-x k stops prompting for buffer to kill
   ([remap delete-horizontal-space] . cycle-spacing) ; M-\. Called twice, cycle-spacing has same effect and its default binding (M-SPC) is problematic in macOS
   )
  :custom
  (column-number-mode t)
  (completion-ignore-case t)
  (completions-detailed t)
  (help-window-select t)
  (history-length 300)
  (inhibit-startup-message t)
  (initial-scratch-message "")
  (kill-do-not-save-duplicates t)
  (create-lockfiles nil)   ; No lock files
  (make-backup-files nil)  ; No backup files
  (read-answer-short t)
  (recentf-max-saved-items 300) ; default is 20
  (recentf-max-menu-items 15)
  (tab-width 4)
  ;; (recentf-exclude (list "^/\\(?:ssh\\|su\\|sudo\\)?:"))
  (treesit-font-lock-level 4)
  (use-dialog-box nil)
  (use-file-dialog nil)
  (use-short-answers t)
  (xref-search-program 'ripgrep)        ; TODO: make it dinamic check if ripgrep is available before setting it and if it costs too much of the init time
  (grep-command "rg -nS --no-heading ") ; TODO: make it dinamic check if ripgrep is available before setting it and if it costs too much of the init time
  (grep-find-ignored-directories
   '("SCCS" "RCS" "CVS" "MCVS" ".src" ".svn" ".jj" ".git" ".hg" ".bzr" "_MTN" "_darcs" "{arch}" "node_modules" "build" "dist"))

  (large-file-warning-threshold nil)
  ;; Follow symlinks to VC-controlled files without warning
  (vc-follow-symlinks t)
  ;; Silence compiler warnings as they can be pretty disruptive
  (native-comp-async-report-warnings-errors nil)
  :init
  (recentf-mode 1)
  (repeat-mode 1)
  (savehist-mode 1)
  (save-place-mode 1))

(use-package auth-source
  :ensure nil
  :custom
  (auth-source-debug t))


(use-package autorevert
  :ensure nil
  :config
  (global-auto-revert-mode 1))

(use-package isearch
  :ensure nil
  :custom
  (isearch-lazy-count t))


(use-package ediff
  :ensure nil
  :custom
  (ediff-split-window-function 'split-window-horizontally)
  (ediff-window-setup-function 'ediff-setup-windows-plain)
  (ediff-keep-variants nil)
  (ediff-make-buffers-readonly-at-startup nil)
  (ediff-merge-revisions-with-ancestor t)
  (ediff-show-clashes-only t))

(use-package server
  :ensure nil
  :config
  (unless (or (server-running-p) (daemonp))
    (server-start)))

(use-package gcmh
  :config
  (gcmh-mode 1))

(setq help-at-pt-display-when-idle t) 
(setq initial-scratch-message ";; What's the QUESTION today?\n\n")

;; Instruct Emacs to use a posix shell under the hood...
(setq shell-file-name (executable-find "bash"))

;; But use your normal shell in terminal emulators
(setq-default explicit-shell-file-name (executable-find "fish"))

(use-package wgrep)

(use-package project
  :ensure nil
  :custom
  (project-list-file (expand-file-name "cache/projects" user-emacs-directory))
  (project-vc-extra-root-markers '("Cargo.toml" "package.json" "go.mod" ".dir-locals.el"))
  :bind
  (:map project-prefix-map
		("v" . magit-project-status))
  :config
  (setq project-switch-commands (assq-delete-all 'project-vc-dir project-switch-commands))
  (add-to-list 'project-switch-commands '(magit-project-status "Magit") t))

(use-package project-x
  :after project
  :custom
  (project-x-window-list-file (expand-file-name "cache/project-window-list" user-emacs-directory))
  :bind
  (:map project-x-layout-map
		("r" . project-x-rename-session))
  :config
  ;; auto-save project state after 5 seconds of idle time
  (setq project-x-auto-save-delay 5) ; nil to disable autosave
  ;; use the custom prompter that shows session labels (optional)
  (setq project-prompter #'project-x--project-prompt)
  (project-x-mode 1))

(use-package nerd-icons-dired
  :hook
  (dired-mode . nerd-icons-dired-mode))

(use-package diredfl
  :hook
  (dired-mode . hl-line-mode)
  (dired-mode . diredfl-mode))

(use-package dired
  :ensure nil
  :general
  (:states 'normal :keymaps 'dired-mode-map
		   "h" #'dired-up-directory
		   "l" #'dired-find-file)
  :custom
  (dired-dwim-target t)
  :config
  (setq dired-listing-switches
        "-l --almost-all --human-readable --group-directories-first --no-group")
  ;; this command is useful when you want to close the window of `dirvish-side'
  ;; automatically when opening a file
  (put 'dired-find-alternate-file 'disabled nil))

(use-package dirvish
  :ensure (:host github :repo "latiagertrutis/dirvish")
  :init
  (dirvish-override-dired-mode)
  :custom
  (dirvish-quick-access-entries ; It's a custom option, `setq' won't work
   '(("h" "~/"                          "Home")
     ("d" "~/Downloads/"                "Downloads")
     ("o" "~/Documents/"                "Documents")
	 ("p" "~/Pictures/"                 "Pictures")
     ("c" "~/.config/"                  "config")
     ("m" "/mnt/"                       "Drives")
     ("t" "~/.local/share/Trash/files/" "TrashCan")))
  (dirvish-default-layout '(0 0.4 0.55))
  ;; (dirvish-reuse-session nil)
  :config
  ;; (dirvish-peek-mode)             ; Preview files in minibuffer
  ;; (dirvish-side-follow-mode)      ; similar to `treemacs-follow-mode'
  (setq dirvish-mode-line-format
        '(:left (sort symlink) :right (omit yank index)))
  (setq dirvish-attributes           ; The order *MATTERS* for some attributes
        '(vc-state subtree-state collapse git-msg file-time file-size)
        dirvish-side-attributes
        '(vc-state collapse file-modes file-size))
  ;; open large directory (over 20000 files) asynchronously with `fd' command
  (setq dirvish-large-directory-threshold 20000)
  (dirvish-define-preview eza (file)
    "Use `eza' to generate directory preview."
    :require ("eza") ; tell Dirvish to check if we have the executable
    (when (file-directory-p file) ; we only interest in directories here
      `(shell . ("eza" "-al" "--color=always" "--icons=always"
                 "--group-directories-first" ,file))))

  (push 'eza dirvish-preview-dispatchers)
  :general
  (:states 'normal :keymaps 'dirvish-mode-map
   "q" #'dirvish-quit
   "?" #'dirvish-dispatch
   "o" #'dirvish-quick-access
   (kbd "TAB") #'dirvish-subtree-toggle
   "f" #'dirvish-file-info-menu
   ;; "l" #'dirvish-ls-switches-menu
   "s" #'dirvish-quicksort
   "*" #'dirvish-mark-menu
   "y" #'dirvish-yank-menu
   "N" #'dirvish-narrow)

  :hook
  (dirvish-setup . dirvish-emerge-mode)
  :bind
  (("C-c d d" . dirvish)
   ("C-c d s" . dirvish-side)
   ("C-c d q" . dirvish-quick-access)
   :map dirvish-mode-map
   ("^"   . dirvish-history-last)
   ("M-f" . dirvish-history-go-forward)
   ("M-b" . dirvish-history-go-backward)
   ("M-e" . dirvish-emerge-menu)))

(use-package smartparens
  :hook (prog-mode text-mode markdown-mode)
  :config
  (require 'smartparens-config))

(defun fc/consult-books ()
  "Consult books in the ~/Documents/books/ folder."
  (interactive)
  (consult-fd (expand-file-name "~/Documents/books")))

(use-package consult
  :general
  (general-nmap
	"SPC f" #'consult-ripgrep
	"SPC SPC" #'consult-fd)
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
  (consult-locate-args "plocate --ignore-case")

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

(use-package consult-dir
  :bind (("C-x C-d" . consult-dir)
         :map vertico-map
         ("C-x C-d" . consult-dir)
         ("C-x C-j" . consult-dir-jump-file)))

(use-package helpful
  :general
  (:states 'insert "C-c C-d" #'helpful-at-point)
  (:states 'normal 
		   "SPC hi" #'info-emacs-manual
		   "SPC hr" #'info-display-manual
		   "SPC hf" #'helpful-callable
		   "SPC hv" #'helpful-variable
		   "SPC hk" #'helpful-key
		   "SPC hm" #'describe-mode
		   "SPC hp" #'describe-package
		   "SPC hc" #'helpful-command))
(use-package elisp-demos
  :after helpful
  :config
  (advice-add 'helpful-update :after #'elisp-demos-advice-helpful-update))

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
   ("C-;"     . embark-dwim)        ;; good alternative: M-.
   ("C-h B"   . embark-bindings) ;; alternative for `describe-bindings'
   :map embark-file-map
   ("S"       . sudo-find-file)
   ("M-u"     . 0x0-upload-file)
   :map embark-buffer-map
   ("M-u"     . 0x0-upload)
   :map embark-region-map
   ("M-u"     . 0x0-upload)
   :map vertico-map
   ("C-c C-e" . embark-export)
   ("C-c C-o" . embark-collect)
   ("C-c C-l" . embark-live))
  :init

  ;; Optionally replace the key help with a completing-read interface
  (setq prefix-help-command #'embark-prefix-help-command)

  ;; Show the Embark target at point via Eldoc. You may adjust the
  ;; Eldoc strategy, if you want to see the documentation from
  ;; multiple providers. Beware that using this can be a little
  ;; jarring since the message shown in the minibuffer can be more
  ;; than one line, causing the modeline to move up and down:

  ;; (add-hook 'eldoc-documentation-functions #'embark-eldoc-first-target)

  ;; Add Embark to the mouse context menu. Also enable `context-menu-mode'.
  ;; (context-menu-mode 1)
  ;; (add-hook 'context-menu-functions #'embark-context-menu 100)

  :config
  ;; Hide the mode line of the Embark live/completions buffers
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))

(use-package embark-consult)
(use-package ace-window
  :custom
  (aw-keys '(?q ?w ?e ?r ?a ?s ?d ?f))
  (aw-dispatch-always nil)
  :bind
  ("M-o" . ace-window))

(use-package tramp
  :ensure nil
  :commands (sudo-find-file sudo-this-file)
  :bind ("C-x C-S-f" . sudo-find-file)
  :config
  (defun sudo-find-file (file)
    "Open FILE as root."
    (interactive "FOpen file as root: ")
    (when (file-writable-p file)
      (user-error "File is user writeable, aborting sudo"))
    (find-file (if (file-remote-p file)
                   (concat "/" (file-remote-p file 'method) ":"
                           (file-remote-p file 'user) "@" (file-remote-p file 'host)
                           "|sudo:root@"
                           (file-remote-p file 'host) ":" (file-remote-p file 'localname))
                 (concat "/sudo:root@localhost:" file))))
  (defun sudo-this-file ()
    "Open the current file as root."
    (interactive)
    (sudo-find-file (file-truename buffer-file-name))))

(use-package 0x0
  :ensure (:host codeberg :repo "pkal/0x0.el")
  :commands (0x0-upload 0x0-upload-file)
  :custom (0x0-default-service 'x0)
  :bind ("C-x M-u" . 0x0-upload))

(defvar fc/override-mode-map (make-sparse-keymap)
  "Keymap for the `fc/override-mode'.")

(define-minor-mode fc/override-mode
  "Activate the `fc/override-mode-map'."
  :global t
  :init-value nil
  :keymap fc/override-mode-map)

(fc/override-mode)

(provide 'zfc-base)
