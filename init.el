(set-default-toplevel-value 'lexical-binding t)

;; setup elpaca
(defvar elpaca-installer-version 0.12)
(defvar elpaca-directory (expand-file-name "elpaca/" user-emacs-directory))
(defvar elpaca-builds-directory (expand-file-name "builds/" elpaca-directory))
(defvar elpaca-sources-directory (expand-file-name "sources/" elpaca-directory))
(defvar elpaca-order '(elpaca :repo "https://github.com/progfolio/elpaca.git"
                              :ref nil :depth 1 :inherit ignore
                              :files (:defaults "elpaca-test.el" (:exclude "extensions"))
                              :build (:not elpaca-activate)))
(let* ((repo  (expand-file-name "elpaca/" elpaca-sources-directory))
       (build (expand-file-name "elpaca/" elpaca-builds-directory))
       (order (cdr elpaca-order))
       (default-directory repo))
  (add-to-list 'load-path (if (file-exists-p build) build repo))
  (unless (file-exists-p repo)
    (make-directory repo t)
    (when (<= emacs-major-version 28) (require 'subr-x))
    (condition-case-unless-debug err
        (if-let* ((buffer (pop-to-buffer-same-window "*elpaca-bootstrap*"))
                  ((zerop (apply #'call-process `("git" nil ,buffer t "clone"
                                                  ,@(when-let* ((depth (plist-get order :depth)))
                                                      (list (format "--depth=%d" depth) "--no-single-branch"))
                                                  ,(plist-get order :repo) ,repo))))
                  ((zerop (call-process "git" nil buffer t "checkout"
                                        (or (plist-get order :ref) "--"))))
                  (emacs (concat invocation-directory invocation-name))
                  ((zerop (call-process emacs nil buffer nil "-Q" "-L" "." "--batch"
                                        "--eval" "(byte-recompile-directory \".\" 0 'force)")))
                  ((require 'elpaca))
                  ((elpaca-generate-autoloads "elpaca" repo)))
            (progn (message "%s" (buffer-string)) (kill-buffer buffer))
          (error "%s" (with-current-buffer buffer (buffer-string))))
      ((error) (warn "%s" err) (delete-directory repo 'recursive))))
  (unless (require 'elpaca-autoloads nil t)
    (require 'elpaca)
    (elpaca-generate-autoloads "elpaca" repo)
    (let ((load-source-file-function nil)) (load "./elpaca-autoloads"))))
(add-hook 'after-init-hook #'elpaca-process-queues)
(elpaca `(,@elpaca-order))

(elpaca elpaca-use-package
  ;; Enable use-package :ensure support for Elpaca.
  (elpaca-use-package-mode))

(use-package emacs
  :ensure nil
  :bind                                              ; NOTE: M-x describe-personal-bindings (for all use-packge binds)
  (("M-o" . other-window)
   ("C-x p l". project-list-buffers)
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
  (project-list-file (expand-file-name "cache/projects" user-emacs-directory))
  (project-vc-extra-root-markers '("Cargo.toml" "package.json" "go.mod")) ; Excelent for mono repos with multiple langs, makes Eglot happy
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
  (tooltip-mode nil)
  (recentf-mode 1)
  (repeat-mode 1)
  (savehist-mode 1)
  (save-place-mode 1))

(use-package auth-source
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

;; Add the folder to the search path
(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))
(setq use-package-always-ensure t)

(require 'zfc-macro)
(require 'zfc-evil)
(require 'zfc-ui)
(require 'zfc-base)
(require 'zfc-dev)
(require 'zfc-org)
(require 'zfc-tool)
(require 'zfc-lang)
