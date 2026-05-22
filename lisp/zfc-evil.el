(defvar fc/leader-key "SPC"
  "my leader key.")

(defvar fc/localleader-key ","
  "my local leader key.")

(use-package general
  :ensure (:wait t)
  :config
  (general-create-definer fc/map
    :prefix fc/leader-key))

(use-package evil
  :ensure (:wait t)
  :custom
  (evil-want-keybinding nil)
  :init
  ;; (setq evil-disable-insert-state-bindings t)
  (setq evil-respect-visual-line-mode t)
  (setq evil-want-Y-yank-to-eol t)
  ;; (setq evil-want-C-w-delete t)
  ;; (setq evil-want-C-w-in-emacs-state t)
  (setq evil-undo-system 'undo-fu)
  (global-visual-line-mode 1)
  :config
  (evil-set-leader '(normal visual) (kbd fc/leader-key))
  (evil-set-leader 'normal (kbd fc/localleader-key) t)

  ;; Conflicts with evil-open-below
  (put 'other-window 'repeat-map nil)

  (general-define-key :keymaps 'normal "C-e" #'end-of-line)

  (evil-mode 1))

;; TODO find a way to use it in zfc-ui
;; (fc/map 'normal "tt" #'theme-buffet-a-la-carte)
;; (fc/map 'normal "to" #'theme-buffet-order-other-period)

(use-package evil-collection
  :after evil
  :custom
  (evil-collection-key-blacklist '("SPC"))
  :config
  (delq 'lispy evil-collection-mode-list)
  (evil-collection-init))

(use-package evil-org
  :after org
  :hook (org-mode . (lambda () evil-org-mode))
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
  (after! evil
    (require 'flash-evil)
    (flash-evil-setup t)
    (setq flash-char-jump-labels t))

  (evil-define-key 'normal 'global (kbd "C-s") #'flash-evil-jump)
  (evil-define-key 'normal 'global (kbd "s") #'flash-evil-jump)
  (evil-define-key 'visual 'global (kbd "C-s") #'flash-evil-jump)

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
  (evil-define-key '(normal visual) 'global "gc" #'evilnc-comment-operator)
  (evilnc-default-hotkeys))

(use-package evil-numbers
  :config
  (define-key evil-normal-state-map (kbd "C-c =") 'evil-numbers/inc-at-pt)
  (define-key evil-normal-state-map (kbd "C-c -") 'evil-numbers/dec-at-pt))

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

(fc/map 'normal "ta" #'fc/toggle-alpha-background)

(provide 'zfc-evil)
