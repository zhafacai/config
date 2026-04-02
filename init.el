;;; -*- lexical-binding: t; -*-
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
  ;; (recentf-exclude (list "^/\\(?:ssh\\|su\\|sudo\\)?:"))
  (treesit-font-lock-level 4)
  (use-dialog-box nil)
  (use-file-dialog nil)
  (use-short-answers t)
  (xref-search-program 'ripgrep)        ; TODO: make it dinamic check if ripgrep is available before setting it and if it costs too much of the init time
  (grep-command "rg -nS --no-heading ") ; TODO: make it dinamic check if ripgrep is available before setting it and if it costs too much of the init time
  (grep-find-ignored-directories
   '("SCCS" "RCS" "CVS" "MCVS" ".src" ".svn" ".jj" ".git" ".hg" ".bzr" "_MTN" "_darcs" "{arch}" "node_modules" "build" "dist"))
  :config

  :init
  (tooltip-mode nil)
  (recentf-mode 1)
  (repeat-mode 1)
  (savehist-mode 1)
  (save-place-mode 1))

;; Single VC backend inscreases booting speed
(setq vc-handled-backends '(Git))
(setq auth-source-debug t)

(setq completion-ignore-case t)
;; why do we need this?
(setq native-comp-async-report-warnings-errors 'silent)

(setq inhibit-startup-message t

      ;; No backup files, please
      make-backup-files nil

      ;; Don't warn on large files
      large-file-warning-threshold nil

      ;; Follow symlinks to VC-controlled files without warning
      vc-follow-symlinks t

      ;; Silence compiler warnings as they can be pretty disruptive
      native-comp-async-report-warnings-errors nil)
(auto-save-visited-mode 1)     ;; Auto-save files at an interval
(load-file (expand-file-name "config.el" user-emacs-directory))
