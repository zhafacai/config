;;; -*- lexical-binding: t -*-
(use-package reader
  :ensure nil
  :hook (reader-mode .
					 (lambda ()
                       (hl-line-mode 0)
                       (set-window-dedicated-p (selected-window) nil)
                       (delete-other-windows))))

(use-package nov
  :config
  (add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode)))

(use-package cal-china-x
  :demand t
  :hook
  (ef-themes-post-load . fc/cal-china-x-custom-faces)
  :config
  (defun fc/cal-china-x-custom-faces ()
    "Customize faces using the current Ef theme's palette."
    (ef-themes-with-colors
      (custom-set-faces
       `(cal-china-x-general-holiday-face ((t (:foreground ,green-warmer))))
       `(cal-china-x-important-holiday-face ((t (:foreground ,red-warmer :weight bold)))))))
  (fc/cal-china-x-custom-faces)
  (setq calendar-mark-holidays-flag t)
  (setq cal-china-x-important-holidays cal-china-x-chinese-holidays)

  (setq cal-china-x-general-holidays
        (append
         '((holiday-lunar 1 15 "元宵节")
           (holiday-lunar 7 7 "七夕节")
           (holiday-lunar 7 15 "中元节")
           (holiday-lunar 9 9 "重阳节")
           (holiday-lunar 12 8 "腊八节")
           (holiday-lunar 12 23 "小年")
           (holiday-solar-term "冬至" "冬至"))

         '((holiday-fixed 2 14 "情人节")
           (holiday-fixed 4 1 "愚人节")
           (holiday-float 11 4 4 "感恩节")
           (holiday-fixed 10 31 "万圣节前夜")
           (holiday-fixed 12 24 "平安夜")
           (holiday-fixed 12 25 "圣诞节")
           (holiday-float 5 0 2 "母亲节")
           (holiday-float 6 0 3 "父亲节"))))
  
  (setq calendar-holidays
        (append cal-china-x-important-holidays
                cal-china-x-general-holidays)))

(use-package elfeed
  :bind
  ("C-c f" . elfeed)
  (:map elfeed-search-mode-map
        ("g" . elfeed-update)
        ("G" . revert-buffer)))
;; FIXME this file does not exist yet
(use-package elfeed-org
  :custom
  (rmh-elfeed-org-files '("/run/user/1000/secrets/elfeed.org"))
  :config
  (elfeed-org))

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

(use-package magit
  :config
  (add-hook 'magit-process-find-password-functions 'magit-process-password-auth-source)
  :custom
  (magit-display-buffer-function #'magit-display-buffer-fullframe-status-v1))

(use-package majutsu
  :vc (:url "https://github.com/0WD0/majutsu" :rev :newest)
  :bind
  ("C-x j" . majutsu)
  :custom
  (majutsu-display-buffer-function #'majutsu-display-buffer-fullcolumn-most-v1)
  :config
  (require 'majutsu-forge)
  (majutsu-forge-mode 1))

(use-package diff-hl
  :init
  (global-diff-hl-mode)
  :custom
  (diff-hl-draw-borders nil)
  :config
  (diff-hl-flydiff-mode 1)
  (add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh)
  (advice-add 'diff-hl-next-hunk :after
			  (defun fc/diff-hl-recenter (&optional _)
				(when (derived-mode-p 'org-mode)
				  (org-show-context 'org-goto))
				(recenter))))

(use-package browse-at-remote)

(use-package forge
  :after magit)

(use-package git-timemachine)

(use-package git-modes)

(use-package rime
  :ensure nil
  :custom
  (default-input-method "rime")
  :config
  (setq rime-user-data-dir "~/.local/share/fcitx5/rime/")
  (setq rime-share-data-dir "/usr/share/rime-data/"))

(use-package emacs-everywhere
  :config
  (setq emacs-everywhere-system-configs
		(append emacs-everywhere-system-configs
				'(((wayland . niri)
				   :focus-command ("niri" "msg" "action" "focus-window" "--id" "%w")
				   :paste-command ("wtype" "-M" "Shift" "-P" "Insert" "-m" "Shift" "-p" "Insert")
				   :info-function emacs-everywhere--app-info-linux-niri))))


  (defun emacs-everywhere--app-info-linux-niri ()
	"Return information on the current active window, on a Linux Niri session."
	(require 'json)
	(let*
		((json-raw (emacs-everywhere--call "niri" "msg" "-j" "focused-window"))
		 (is-err (string-prefix-p "Error" json-raw)))
	  (if is-err
		  (progn
			(message "[emacs-everywhere] %s" json-raw)
			(message "[emacs-everywhere] NIRI_SOCKET=%s" (getenv "NIRI_SOCKET"))
			(error "[emacs-everywhere] Error in `niri msg -j focused-window' (see *messages*)"))
		(let*
			((json (json-read-from-string json-raw)) ;; -j for json
			 (wid (cdr (assq 'id json)))
			 (window-id (if (numberp wid) (number-to-string wid) wid))
			 (window-title (cdr (assq 'title json)))
			 (app-name (cdr (assq 'app_id json)))
			 (window-geometry nil)) ;; no geometry in niri
		  (make-emacs-everywhere-app
		   :id window-id
		   :class app-name
		   :title window-title
		   :geometry window-geometry))))))

(use-package guix
  :ensure nil
  ;; override insert-file in emacs
  :bind
  ("C-x i" . guix))

(use-package gt
  :commands (gt-translate)
  :config
  (setq gt-langs '(en zh))
  (setq gt-default-translator
        (gt-translator :engines (gt-stardict-engine
                                 :dir "~/.stardict/dic"
                                 :exact nil)))
  :bind
  ("C-x l" . gt-translate))

(use-package sops
  ;; :ensure (:type git :host github :repo "djgoku/sops")
  ;; BUG this is so laggy
  :init
  ;; (setq sops-before-encrypt-decrypt-hook 'sops-setup-env)
  (global-sops-mode 1))

(use-package yaml-mode
  :mode ("\\.yaml\\'" . yaml-mode))

(use-package blue
  :init
  ;; Enable custom filters to handle different escape sequences in compilation
  ;; and comint buffers.
  (blue-prettify-compilation-mode 1))

(use-package ghostel-ime
  :ensure nil
  :hook (ghostel-mode . ghostel-ime-mode))

(use-package ghostel
  :custom
  (ghostel-shell "fish")
  :hook
  (after-init . ghostel-comint-global-mode)
  ;; (ghostel-mode . ghostel-ime-mode)
  :bind (("C-x m" . ghostel)
         :map ghostel-semi-char-mode-map
         ("C-s"  . consult-line)
         ("C-k"  . my/ghostel-send-C-k-and-kill)
         :map project-prefix-map
         ("m" . ghostel-project)
         ("M" . ghostel-project-list-buffers))
  :config
  (defun my/ghostel-send-C-k-and-kill ()
    "Send `C-k' to ghostel.
Like normal Emacs `C-k'.  Kill to end of line and put content in kill-ring."
    (interactive)
    (kill-ring-save (point) (line-end-position))
    (ghostel-send-key "k" "ctrl"))

  (add-to-list 'project-switch-commands '(ghostel-project "Ghostel") t)
  (add-to-list 'project-switch-commands '(ghostel-project-list-buffers "Ghostel buffers") t)
  (add-to-list 'ghostel-eval-cmds '("magit-status-setup-buffer" magit-status-setup-buffer)))

;; (use-package direnv
;;   :config
;;   (direnv-mode))
(use-package ben
  :vc (:url "https://codeberg.org/pastor/ben.el")
  :bind-keymap
  ("C-c E" . ben-command-map)
  :config
  (setq ben-indicator `(,(substring-no-properties (nerd-icons-faicon "nf-fa-cubes"))
                        " [" (:eval (ben--status)) "]")
        ben-status-frames
        '("⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏"))
  :init
  (add-hook 'after-init-hook #'ben-global-mode 99))

(use-package dwim-shell-command
  :custom
  (dwim-shell-commands-git-clone-dirs '("~/repo" "~/Downloads"))
  :bind (([remap shell-command] . dwim-shell-command)
         :map dired-mode-map
         ([remap dired-do-async-shell-command] . dwim-shell-command)
         ([remap dired-do-shell-command] . dwim-shell-command)
         ([remap dired-smart-shell-command] . dwim-shell-command))
  :config
  (defun dwim-shell-commands-video-convert-to-mp4 ()
    "Convert to any video to mp4"
    (interactive)
    (dwim-shell-command-on-marked-files
     "Convert to video to mp4"
     "ffmpeg -i '<<f>>' -c:v libx264 -c:a aac -movflags +faststart '<<fne>>'.mp4"
     :utils "ffmpeg"))
  (require 'dwim-shell-commands))

(use-package transient :ensure t)

(use-package gptel
  :custom
  (gptel-default-mode #'org-mode)
  :hook (gptel-mode . gptel-highlight-mode)
  :bind
  (("C-c a p" . gptel)
   ("C-c a r" . gptel-rewrite)
   ("C-c a a" . gptel-add)
   ("C-c a f" . gptel-add-file)
   ("C-c a m" . gptel-menu))
  :config
  (define-key fc/override-mode-map (kbd "C-c C-<return>") 'gptel-send)
  
  (gptel-make-openai "BigModel"
	:host "open.bigmodel.cn"
	:endpoint "/api/paas/v4/chat/completions"
	:key #'gptel-api-key-from-auth-source
	:stream t
	:models '(glm-5.3-flash))
  
  (gptel-make-openai "OpenRouter"
	:host "openrouter.ai"
	:endpoint "/api/v1/chat/completions"
	:key #'gptel-api-key-from-auth-source
	:stream t
	:models '(poolside/laguna-s-2.1:free
              z-ai/glm-5.2:free
			  nvidia/nemotron-3-ultra-550b-a55b:free))

  (gptel-make-openai "Flash"
	:host "ark.cn-beijing.volces.com"
	:endpoint "/api/coding/v3/chat/completions"
	:key #'gptel-api-key-from-auth-source
	:stream t
	:request-params '(:thinking (:type "disabled"))
	:models '(deepseek-v4-flash-ga-260731))
  
  (gptel-make-openai "Dots"
	:host "note3-prev-api.askdiandian.com"
	:endpoint "/v1/chat/completions"
	:key #'gptel-api-key-from-auth-source
	:stream t
	:models '(dots3-note-prev))
  
  (gptel-make-openai-responses "ByteDance(response)"
	:host "ark.cn-beijing.volces.com"
	:endpoint "/api/coding/v3/responses"
	:key #'gptel-api-key-from-auth-source
	:stream t
	:models '(deepseek-v4-flash
			  deepseek-v4-flash-ga-260731
			  doubao-seed-evolving))

  (gptel-make-openai "ByteDance"
	:host "ark.cn-beijing.volces.com"
	:endpoint "/api/coding/v3/chat/completions"
	:key #'gptel-api-key-from-auth-source
	:stream t
	:models '(deepseek-v4-flash
			  deepseek-v4-flash-ga-260731
			  doubao-seed-evolving))

  (gptel-make-openai "Nim"
	:host "integrate.api.nvidia.com"
	:endpoint "/v1/chat/completions"
	:key #'gptel-api-key-from-auth-source
	:stream t
	:models '(nvidia/nemotron-3-ultra-550b-a55b
			  z-ai/glm-5.2
			  thinkingmachines/inkling))
  
  (gptel-make-openai "SenseNova"
	:host "token.sensenova.cn"
	:endpoint "/v1/chat/completions"
	:key #'gptel-api-key-from-auth-source
	:stream t
	:models '(sensenova-6.8-flash-lite
			  glm-5.2
			  deepseek-v4-flash))

  (setq gptel-backend (gptel-get-backend "BigModel"))
  (setq gptel-model 'glm-5.3-flash)
  ;; (setq gptel-backend (gptel-get-backend "SenseNova"))
  ;; (setq gptel-model 'sensenova-6.8-flash-lite)
  )

(use-package gptel-agent
  :config (gptel-agent-update))

(use-package ob-gptel
  :vc (:url "https://github.com/jwiegley/ob-gptel")
  :config
  (add-to-list 'org-babel-load-languages '(gptel . t))
  (defun ob-gptel-setup-completions ()
    (add-hook 'completion-at-point-functions
              'ob-gptel-capf nil t))
  :hook (org-mode . ob-gptel-setup-completions))

(use-package gptel-prompts
  :vc (:url "https://github.com/jwiegley/gptel-prompts")
  :after (gptel)
  :demand t
  :custom
  (gptel-prompts-directory "~/config/prompts")
  :config
  (gptel-prompts-update)
  ;; Ensure prompts are updated if prompt files change
  ;; (gptel-prompts-add-update-watchers)
  )


(use-package gptel-magit
  :vc (:url "https://github.com/roife/gptel-magit")
  :hook (magit-mode . gptel-magit-install))


(use-package gptel-quick
  :vc (:url "https://github.com/karthink/gptel-quick")
  :after embark
  :custom
  (gptel-quick-backend (gptel-get-backend "Flash"))
  (gptel-quick-model 'deepseek-v4-flash-ga-260731)
  :bind (:map embark-region-map
              ("?" . gptel-quick)
              :map embark-identifier-map
              ("?" . gptel-quick))
  :config
  (setq gptel-quick-system-message (lambda (count)
								     (format "Explain in %d words or fewer in Chinese." count))))

(use-package agent-shell
  :bind
  ("C-c a s" . agent-shell)
  :custom
  (agent-shell-preferred-agent-config '(preselect . opencode))
  ;; BUG https://github.com/niri-wm/niri/issues/2664
  (agent-shell-screenshot-command '("niri" "msg" "action" "screenshot" "--path"))
  (agent-shell-opencode-default-model-id "sensenova/deepseek-v4-flash"))


(use-package agent-shell-dashboard
  :vc (:url "https://github.com/wandersoncferreira/agent-shell-dashboard")
  :bind
  ("C-c a d" . agent-shell-dashboard)
  :custom
  ;; (initial-buffer-choice #'agent-shell-dashboard)
  (agent-shell-dashboard-excerpt-function #'agent-shell-dashboard-excerpt-tail))

;; (setq epg-pinentry-mode 'loopback) 
(setq epa-file-encrypt-to '("zhafacai@gmail.com"))

(setq auth-sources '("~/.authinfo.gpg")
      user-full-name "zhafacai"
      user-mail-address "zhafacai@gmail.com")

(setq smtpmail-smtp-server "smtp.gmail.com"
      smtpmail-smtp-service 587
      smtpmail-stream-type 'starttls)

(setq message-send-mail-function 'smtpmail-send-it)

(use-package notmuch
  :ensure nil
  :hook
  (notmuch-hello-mode . notmuch-poll-and-refresh-this-buffer)
  :bind
  ("C-c j" . notmuch)
  :config
  (setq notmuch-identities '("zfc <zhafacai@gmail.com>"))
  (setq notmuch-fcc-dirs nil)
  (setq notmuch-show-logo t
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
          ( :name "📬 all unread (inbox)"
            :query "tag:unread and tag:inbox"
            :sort-order newest-first
            :key ,(kbd "u"))
          ( :name "🐧 unread dev"
            :query "tag:unread and tag:dev"
            :sort-order newest-first
            :key ,(kbd "d"))
          ( :name "💸 unread crypto"
            :query "tag:unread and tag:crypto"
            :sort-order newest-first
            :key ,(kbd "c")))))

  ;; (setq browse-url-browser-function 'browse-url-generic
;;       browse-url-generic-program "librewolf")


(use-package notmuch-indicator
  :config
  (setq notmuch-indicator-args
		'((:terms "tag:unread and tag:inbox" :label "📬" :label-face success)
		  (:terms "tag:unread and tag:dev" :label "🐧" :label-face warning :counter-face inherit)
		  (:terms "tag:unread and tag:crypto" :label "💸" :label-face bold :counter-face error))

		notmuch-indicator-refresh-count (* 60 3)
		notmuch-indicator-hide-empty-counters t
		notmuch-indicator-force-refresh-commands '(notmuch-refresh-this-buffer))

  (notmuch-indicator-mode 1))

(use-package ol-notmuch
  :after (notmuch org))

(provide 'zfc-tool)
