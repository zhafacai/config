;;; -*- lexical-binding: t -*-
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file nil t))

;; (add-to-list 'default-frame-alist '(fullscreen . maximized))

(add-to-list 'default-frame-alist '(alpha-background . 90))
(setq vc-handled-backends '(Git))

(setq use-short-answers t)

(setq frame-resize-pixelwise t
      frame-inhibit-implied-resize t
      frame-title-format
      '(:eval
        (let ((project (project-current)))
          (if project
              (concat "[p] " (project-name project))
            (buffer-name)))))


(setq inhibit-compacting-font-caches t)


;; Disables unused UI Elements
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'tooltip-mode) (tooltip-mode -1))

;; Avoid raising the *Messages* buffer if anything is still without
;; lexical bindings
(setq warning-minimum-level :error)
;; (setq warning-suppress-types '((lexical-binding)))

(setq package-enable-at-startup nil)
