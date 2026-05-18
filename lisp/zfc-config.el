;; -*- lexical-binding: t; -*-
(defun fc/toggle-alpha-background ()
  "toggle tranparency of background"
  (interactive)
  (let ((current (frame-parameter nil 'alpha-background)))
    (set-frame-parameter nil 'alpha-background
                         (if (or (null current) (>= current 98))
                             90
                           100))))
(add-to-list 'default-frame-alist '(alpha-background . 90))

(fc/map 'normal "ta" #'fc/toggle-alpha-background)

(defun fc/next-wallpaper ()
  "Call next wallpaper."
  (interactive)
  (shell-command "noctalia-shell ipc call wallpaper random"))

(fc/map 'normal "tn" #'fc/next-wallpaper)

(use-package gcmh
  :config
  (gcmh-mode 1))

(setq help-at-pt-display-when-idle t) 
(setq initial-scratch-message ";; What's the QUESTION today?\n\n")

;; Instruct Emacs to use a posix shell under the hood...
(setq shell-file-name (executable-find "bash"))

;; But use your normal shell in terminal emulators
(setq-default explicit-shell-file-name (executable-find "fish"))

(use-package tracking)

(use-package telega
  :ensure nil
  :bind
  ("C-c t" . telega)
  :commands telega
  :config
  (setq telega-use-tracking-for '(or unmuted mention)
        telega-completing-read-function #'completing-read
        telega-msg-rainbow-title t
        telega-chat-fill-column 75)

  ;; Show notifications in the mode line
  (add-hook 'telega-load-hook #'telega-mode-line-hook)

  ;; Disable chat buffer auto-fill
  (add-hook 'telega-chat-mode-hook #'telega-chat-auto-fill-mode))

(use-package reader
  :ensure nil
  :hook (reader-mode . (lambda () (hl-line-mode 0))))

(use-package rime
  :ensure nil
  :custom
  (default-input-method "rime")
  :config
  (setq rime-user-data-dir "~/.local/share/fcitx5/rime/"))

(use-package guix
  :ensure nil
  :bind
  (:map evil-normal-state-map
        ("SPC g i" . guix)))

(setq auth-sources '("~/.authinfo.gpg")
      user-full-name "zhafacai"
      user-mail-address "zhafacai@gmail.com")

(setq smtpmail-smtp-server "smtp.gmail.com"
      smtpmail-smtp-service 587
      smtpmail-stream-type 'starttls)

(setq message-send-mail-function 'smtpmail-send-it)

(use-package notmuch
  :ensure nil
  :bind
  ("C-c e" . notmuch)
  :config
  (setq notmuch-identities '("zfc <zhafacai@gmail.com>"))
  (setq notmuch-fcc-dirs
        '(("zhafacai@gmail.com" . "gmail/Sent")))
  (setq notmuch-show-logo nil
        notmuch-column-control 1.0
        notmuch-hello-auto-refresh t
        notmuch-hello-recent-searches-max 20
        notmuch-hello-thousands-separator ""
        notmuch-hello-sections '(notmuch-hello-insert-saved-searches)
        notmuch-show-all-tags-list t)

  (setq notmuch-search-oldest-first nil)

  (setq notmuch-saved-searches
        `(( :name "📥 inbox"
            :query "tag:inbox"
            :sort-order newest-first
            :key ,(kbd "i"))
          ( :name "💬 all unread (inbox)"
            :query "tag:unread and tag:inbox"
            :sort-order newest-first
            :key ,(kbd "u"))
          ( :name "🔮 unread crypto"
            :query "tag:unread and tag:crypto"
            :sort-order newest-first
            :key ,(kbd "c"))
          ( :name "🌞 unread life"
            :query "tag:unread and tag:life"
            :sort-order newest-first
            :key ,(kbd "l")))))


(setq browse-url-browser-function 'browse-url-generic
      browse-url-generic-program "librewolf")

(provide 'zfc-config)
