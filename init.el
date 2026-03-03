;;; -*- lexical-binding: t; -*-
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
