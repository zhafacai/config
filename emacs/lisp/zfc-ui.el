;;; -*- lexical-binding: t -*-
(add-to-list 'custom-theme-load-path (expand-file-name "lisp" user-emacs-directory))

(use-package ef-themes
  :bind
  ("C-c w d" . ef-themes-load-random-dark)
  ("C-c w l" . ef-themes-load-random-light)
  :init
  ;; oxocarbon lives in emacs/lisp (see `custom-theme-load-path' above)
  (load-theme 'oxocarbon :no-confirm))

(use-package spacious-padding
  :custom
  (spacious-padding-widths
   '(:internal-border-width 10
     :header-line-width 4
     :mode-line-width 6
     :tab-bar-width 4))
  :config
  (spacious-padding-mode 1))

(use-package logos
  :config
  ;; If you want to use outlines instead of page breaks (the ^L):
  (setq logos-outlines-are-pages t)

  ;; This is the default value for the outlines:
  (setq logos-outline-regexp-alist
        `((emacs-lisp-mode . "^;;;+ ")
          (org-mode . "^\\*+ +")
          (markdown-mode . "^\\#+ +")))

  ;; These apply when `logos-focus-mode' is enabled.  Their value is
  ;; buffer-local.
  (setq-default logos-hide-cursor nil
                logos-hide-mode-line t
                logos-hide-header-line t
                logos-hide-buffer-boundaries t
                logos-hide-fringe t
                logos-variable-pitch nil
                logos-buffer-read-only nil
                logos-scroll-lock nil
                logos-olivetti nil)


  (let ((map global-map))
    (define-key map [remap narrow-to-region] #'logos-narrow-dwim)
    (define-key map [remap forward-page] #'logos-forward-page-dwim)
    (define-key map [remap backward-page] #'logos-backward-page-dwim)))

(use-package olivetti
  :hook
  (Info-mode . (lambda ()
				 (setq-local olivetti-minimum-body-width fill-column)
				 (setq-local olivetti-body-width 0.3)
				 (olivetti-mode)))
  (nov-mode . olivetti-mode)
  :bind
  ("C-c O" . olivetti-mode)
  :custom
  (olivetti-minimum-body-width 80)
  (olivetti-recall-visual-line-mode-entry-state t)
  :config
  (setq-default olivetti-body-width 0.5))

(use-package colorful-mode
  :custom
  (colorful-use-prefix t)
  (colorful-only-strings 'only-prog)
  (css-fontify-colors nil)
  :config
  (global-colorful-mode t)
  (add-to-list 'global-colorful-modes 'helpful-mode))

(use-package emacs
  :ensure nil
  :bind
  ("C-c w w" . fc/wallpaper-random)
  :config
  (defun fc/wallpaper-random ()
    "Switch to a random wallpaper using noctalia-shell."
    (interactive)
    (call-process "noctalia" nil 0 nil "msg" "wallpaper-random")
    (message "Wallpaper changed 😃")))

(set-face-attribute 'default nil
                    :family "Iosevka SS17"
                    :height 150)

(set-face-attribute 'variable-pitch nil
                    :family "Iosevka Slab")

(set-face-attribute 'fixed-pitch nil
                    :family "Iosevka SS02")

(set-face-attribute 'fixed-pitch-serif nil
                    :family "Iosevka SS08")

(dolist (charset '(kana han cjk-misc symbol bopomofo))
  (set-fontset-font t charset (font-spec :family "LXGW Marker Gothic")))

(use-package hl-todo
  :hook (prog-mode . hl-todo-mode)
  :bind
  (:map prog-mode-map
	("M-g t" . hl-todo-next)
	("M-g T" . hl-todo-previous)))

(use-package doom-modeline
  :config
  (setq doom-modeline-check nil)
  (setq doom-modeline-buffer-encoding nil)
  (setq doom-modeline-always-show-macro-register t)
  (setq doom-modeline-position-column-line-format '(""))

  :init (doom-modeline-mode 1))

(use-package pulsar
  :config
  (dolist (fn '(pulsar-pulse-line-red pulsar-recenter-top pulsar-reveal-entry))
    (add-hook 'minibuffer-setup-hook fn))
  (setq pulsar-delay 0.045
        pulsar-iterations 4
        pulsar-face 'pulsar-green
        pulsar-region-face 'pulsar-yellow
        pulsar-highlight-face 'pulsar-magenta)
  (pulsar-global-mode 1))

(use-package theme-buffet
  :ensure (:wait t)
  :config
  (setq theme-buffet-menu 'end-user)

  (setq theme-buffet-end-user
        '( :night     (oxocarbon ef-dark ef-winter ef-autumn ef-night ef-duo-dark ef-symbiosis)
           :morning   (oxocarbon-light ef-light ef-cyprus ef-spring ef-frost ef-duo-light)
           :afternoon (oxocarbon-light ef-arbutus ef-day ef-kassio ef-summer ef-elea-light ef-maris-light ef-melissa-light ef-trio-light ef-reverie)
           :evening   (oxocarbon ef-rosa ef-elea-dark ef-maris-dark ef-melissa-dark ef-trio-dark ef-dream)))


  (theme-buffet-timer-hours 1))

(use-package rainbow-delimiters
  :hook
  (prog-mode . rainbow-delimiters-mode))

(use-package nyan-mode
  :custom
  (nyan-wavy-trail t)
  (nyan-animate-nyancat t)
  (nyan-bar-length 15)
  :config
  (nyan-mode))

(use-package which-key
  :custom
  (which-key-idle-delay 0.5)
  :init
  (which-key-mode))

(use-package lin
  :config
  (setopt lin-face 'lin-blue) ; check doc string for alternative styles
  
  (global-hl-line-mode 1)
  (lin-global-mode 1)

  ;; If you are using the GNOME desktop and want to synchronise the
  ;; `lin-face' with GNOME's accent colour:
  (lin-gnome-accent-color-mode 1))

(use-package idle-highlight-mode
  :config (setq idle-highlight-idle-time 0.2)
  :hook (eglot--managed-mode . idle-highlight-mode))

(provide 'zfc-ui)
