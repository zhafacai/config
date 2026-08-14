;;; -*- lexical-binding: t -*-
(defvar fc/override-mode-map (make-sparse-keymap)
  "Keymap for the `fc/override-mode'.")

(define-minor-mode fc/override-mode
  "Activate the `fc/override-mode-map'."
  :global t
  :init-value nil
  :keymap fc/override-mode-map)

(fc/override-mode)

(use-package flash
  :commands (flash-jump flash-jump-continue
                        flash-treesitter)
  :bind
  ("C-s" . flash-jump)
  :custom
  (flash-multi-window t)
  ;; (flash-autojump t)
  (flash-rainbow t)
  :config
  ;; Search integration (labels during C-s, /, ?)
  (require 'flash-isearch)
  (flash-isearch-mode 1))

;; (use-package avy
;;   :config
;;   (avy-setup-default))

(use-package expand-region
  :bind ("C-," . er/expand-region)
  :config
  (add-to-list 'expand-region-exclude-text-mode-expansions 'org-mode))

(use-package embrace
  :bind
  ("M-s a" . embrace-add)
  ("M-s c" . embrace-change)
  ("M-s d" . embrace-delete))

(use-package undo-fu-session
  :hook ((prog-mode conf-mode text-mode tex-mode) . undo-fu-session-mode)
  :config
  (setq undo-fu-session-directory
        (expand-file-name "cache/undo-fu-session" user-emacs-directory)))

(use-package multiple-cursors
  :bind
  ("C-S-c C-S-c" . mc/edit-lines))

;; (use-package evil-lion
;;   :config
;;   (evil-lion-mode))

(use-package anzu
  :config
  (global-anzu-mode +1))

(defun fc/toggle-alpha-background ()
  "toggle tranparency of background"
  (interactive)
  (let ((current (frame-parameter nil 'alpha-background)))
    (set-frame-parameter nil 'alpha-background
                         (if (or (null current) (>= current 98))
                             90
                           100))))

(provide 'zfc-edit)
