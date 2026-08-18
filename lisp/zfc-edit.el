;;; -*- lexical-binding: t -*-
(defvar fc/override-mode-map (make-sparse-keymap)
  "Keymap for the `fc/override-mode'.")

(define-minor-mode fc/override-mode
  "Activate the `fc/override-mode-map'."
  :global t
  :init-value nil
  :keymap fc/override-mode-map)

(fc/override-mode)

;; Jump/navigate — kept on M-s, the search prefix, because these *locate*
;; things.  All copy/kill/move editing lives under `C-c e' below so that M-s
;; stays a pure search prefix.
(use-package avy
  :bind
  ("M-s M-j" . avy-goto-char-2)
  ("M-s M-s" . avy-goto-line)
  ("M-s M-l" . avy-goto-end-of-line)
  ;; Editing actions under the `C-c e' (edit) prefix.  `C-c e' is free globally
  ;; and in org; notmuch moved to `C-c m' so this prefix stays unambiguous.
  ;; Case convention: lower-case = current line, upper-case = region.
  ("C-c e y" . avy-copy-line)
  ("C-c e Y" . avy-copy-region)
  ("C-c e k" . avy-kill-whole-line)
  ("C-c e K" . avy-kill-region)
  ("C-c e w" . avy-kill-ring-save-region)
  ("C-c e m" . avy-move-line)
  ("C-c e M" . avy-move-region)
  :config
  (avy-setup-default))

(use-package expand-region
  :bind
  (:map fc/override-mode-map
        ("C-," . er/expand-region))
  ("C-=" . er/expand-region)
  :config
  (add-to-list 'expand-region-exclude-text-mode-expansions 'org-mode))

(use-package embrace
  :bind
  (("C-c e a" . embrace-add)
   ("C-c e c" . embrace-change)
   ("C-c e d" . embrace-delete)))

(use-package move-text
  :bind
  (("C-c e N" . move-text-down)
   ("C-c e P" . move-text-up)))

(use-package crux
  :bind
  (("C-S-o" . crux-smart-open-line-above)
   ("C-k" . crux-smart-kill-line)))

(use-package mwim
  :bind
  (("C-a" . mwim-beginning)
   ("C-e" . mwim-end)))

(use-package undo-fu-session
  :hook ((prog-mode conf-mode text-mode tex-mode) . undo-fu-session-mode)
  :config
  (setq undo-fu-session-directory
        (expand-file-name "cache/undo-fu-session" user-emacs-directory)))

(use-package multiple-cursors
  :bind
  (("C-c e e" . mc/edit-lines)
   ("C-c e o" . mc/mark-all-like-this-dwim)
   ("C-c e n" . mc/mark-next-like-this-word)
   ("C-c e p" . mc/mark-previous-like-this-word)))

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
