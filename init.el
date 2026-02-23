;;; -*- lexical-binding: t; -*-
(defconst fc/is-windows (eq system-type 'windows-nt))
(defconst fc/is-linux   (eq system-type 'gnu/linux))

;; -----------------------
;; Linux 发行版判断
;; -----------------------
(defun fc/linux-distro ()
  "Return a symbol identifying the Linux distribution."
  (when fc/is-linux
    (cond
     ;; ArchLinux (检测 arch-release 文件)
     ((file-exists-p "/etc/arch-release") 'arch)
     ;; NixOS
     ((file-exists-p "/etc/nixos") 'nixos)
     ;; Guix
     ((file-exists-p "/etc/guix") 'guix)
     ;; fallback
     (t 'linux))))

(defconst fc/is-nixos  (eq (fc/linux-distro) 'nixos))
(defconst fc/is-guix   (eq (fc/linux-distro) 'guix))
(defconst fc/is-arch   (eq (fc/linux-distro) 'arch))

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
