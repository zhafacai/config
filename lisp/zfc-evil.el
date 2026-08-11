(defvar fc/leader-key "SPC"
  "my leader key.")

(defvar fc/localleader-key ","
  "my local leader key.")

(use-package general
  :ensure (:wait t)
  :config
  (general-evil-setup))

(use-package evil
  :ensure (:wait t)
  :custom
  (evil-want-keybinding nil)
  :init
  (setq evil-disable-insert-state-bindings t)
  (setq evil-respect-visual-line-mode t)
  (setq evil-want-Y-yank-to-eol t)
  (setq evil-undo-system 'undo-fu)
  (global-visual-line-mode 1)
  :config
  (evil-define-key 'normal 'global (kbd "C-.") nil)
  (evil-set-leader '(normal visual) (kbd fc/leader-key))
  (evil-set-leader 'normal (kbd fc/localleader-key) t)

  ;; Conflicts with evil-open-below
  (put 'other-window 'repeat-map nil)

  (general-nmap "C-e" #'end-of-line)

  (evil-mode 1))

(use-package evil-collection
  :after evil
  :custom
  (evil-collection-want-find-usages-bindings nil)
  (evil-collection-key-blacklist '("SPC"))
  :config
  (delq 'lispy evil-collection-mode-list)
  (evil-collection-init))

(use-package evil-org
  :after org
  :hook (org-mode . evil-org-mode)
  :config
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys))

(use-package flash
  :commands (flash-jump flash-jump-continue
                        flash-treesitter)
  :custom
  (flash-multi-window t)
  ;; (flash-autojump t)
  (flash-rainbow t)
  :init
  ;; Evil integration (simple setup)
  (require 'flash-evil)
  (flash-evil-setup t)
  (setq flash-char-jump-labels t)

  :general
  (:states '(normal visual) "C-s" #'flash-evil-jump)
  (:states 'normal "s" #'flash-evil-jump)

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

(use-package evil-escape
  :custom
  (evil-escape-key-sequence "jk")
  (evil-escape-excluded-major-modes '(magit-status-mode))
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
  (evilnc-default-hotkeys)
  :general
  (:states '(normal visual) "gc" #'evilnc-comment-operator))

(use-package evil-numbers
  :general
  (general-nmap
	"C-c =" 'evil-numbers/inc-at-pt
	"C-c -" 'evil-numbers/dec-at-pt))

(use-package exato)

(use-package evil-quick-diff
  :ensure (:host github :repo "rgrinberg/evil-quick-diff")
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

(use-package anzu
  :config
  (global-anzu-mode +1))

(use-package evil-anzu)

(defun fc/toggle-alpha-background ()
  "toggle tranparency of background"
  (interactive)
  (let ((current (frame-parameter nil 'alpha-background)))
    (set-frame-parameter nil 'alpha-background
                         (if (or (null current) (>= current 98))
                             90
                           100))))

(general-nmap "ta" #'fc/toggle-alpha-background)

(provide 'zfc-evil)
