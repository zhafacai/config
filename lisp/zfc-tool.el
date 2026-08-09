(use-package telega
  :ensure nil
  ;; :bind
  ;; ("C-c t" . telega)
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
  :hook (reader-mode .
					 (lambda ()
                       (hl-line-mode 0)
                       (set-window-dedicated-p (selected-window) nil)
                       (delete-other-windows))))

(use-package nov
  :config
  (add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode)))

(use-package elfeed
  :bind
  ("C-c f" . elfeed))
(use-package elfeed-org
  :custom
  (rmh-elfeed-org-files '("/run/user/1000/secrets/elfeed"))
  :config
  (elfeed-org))

(use-package magit
  :general
  (general-nmap "SPC gg" 'magit)
  :config
  (add-hook 'magit-process-find-password-functions 'magit-process-password-auth-source)
  :custom
  (magit-display-buffer-function #'magit-display-buffer-fullframe-status-v1)
  :hook
  (git-commit-mode . evil-insert-state))

(use-package blamer
  ;; :bind (("C-c i" . blamer-show-posframe-commit-info))
  ;; :defer 20
  :general
  (general-nmap "SPC tb" 'blamer-mode)
  :custom
  (blamer-idle-time 0.3)
  (blamer-min-offset 70)
  :config
  (modus-themes-with-colors
    (custom-set-faces
     `(blamer-face ((,c :foreground ,magenta
                        :background nil
                        :height 140
                        :italic t))))))

(use-package diff-hl
  :init
  (global-diff-hl-mode)
  :config
  (add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh)
  :general
  (:states 'normal "]h" #'diff-hl-next-hunk)
  (:states 'normal "[h" #'diff-hl-previous-hunk))

(use-package browse-at-remote
  :general
  (general-nmap  "gb" #'browse-at-remote))

(use-package forge
  :after magit
  :custom
  (forge-add-default-bindings nil))

(use-package git-timemachine
  :general
  (general-nmap "gt" #'git-timemachine))

(use-package git-modes)

(use-package rime
  :ensure nil
  :custom
  (default-input-method "rime")
  :config
  (setq rime-user-data-dir "~/.local/share/fcitx5/rime/"))

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
  :general
  (general-nmap
    "SPC gi" 'guix))


(add-hook 'scheme-mode-hook (lambda () (evil-local-set-key 'normal "K" #'geiser-doc-look-up-manual)))

(use-package gt
  :commands (gt-translate)
  :config
  (setq gt-langs '(en zh))
  (setq gt-default-translator
        (gt-translator :engines (gt-stardict-engine
                                 :dir "~/.stardict/dic"
                                 :exact nil)))
  :general
  (:states 'normal
		   [down-mouse-3] #'gt-translate
		   "SPC l" #'gt-translate))

(use-package sops
  ;; :ensure (:type git :host github :repo "djgoku/sops")
  :bind (("C-c C-c" . sops-save-file)
         ("C-c C-k" . sops-cancel)
         ("C-c C-e" . sops-edit-file))
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

(use-package ghostel
  :ensure t
  :bind
  ("C-c t" . ghostel)
  :custom
  (ghostel-shell "fish"))

  ;; (use-package direnv
  ;;   :config
  ;;   (direnv-mode))
  (use-package ben
    :ensure (:host codeberg :repo "pastor/ben.el")
    :bind
    ("C-c E" . ben-command-map)
    :config
    (setq ben-indicator `(,(substring-no-properties (nerd-icons-faicon "nf-fa-cubes"))
                          "[" (:eval (ben--status)) "]"))
    :init
    (add-hook 'after-init-hook #'ben-global-mode 99))

(use-package emms
  :ensure nil
  :after evil
  :commands emms
  :custom
  ;; (emms-mode-line-format nil)
  (emms-player-list '(emms-player-mpv))
  ;; (emms-lyrics-display-on-modeline nil)
  :config
  (emms-all)
  (emms-add-directory-tree "~/Music/")
  (emms-shuffle)
  ;; Volume commands in repeat mode
  (dolist (elm '(emms-volume-raise
                 emms-volume-lower
		         emms-pause
                 emms-next
                 emms-previous))
    (put elm 'repeat-map 'emms-volume-repeat-map))

  (defvar emms-volume-repeat-map
    (let ((map (make-sparse-keymap)))
      (define-key map "=" #'emms-volume-raise)
      (define-key map "-" #'emms-volume-lower)
      (define-key map (kbd "SPC") #'emms-pause)
      (define-key map "n" #'emms-next)
      (define-key map "p" #'emms-previous)
      map)
    "Keymap for continuous volume adjustment in EMMS")


  (setq emms-volume-change-function 'emms-volume-pulse-change)

  :general
  ("C-c m SPC" #'emms-pause
   "C-c m p" #'emms-previous
   "C-c m n" #'emms-next
   "C-c m s" #'emms-stop
   "C-c m m" #'emms
   "C-c m =" #'emms-volume-raise
   "C-c m -" #'emms-volume-lower)
  (:states 'normal :keymaps 'emms-playlist-mode-map
		   "s" #'emms-sort
		   "q" #'emms-playlist-mode-bury-buffer))

(use-package dwim-shell-command
  :custom
  (dwim-shell-commands-git-clone-dirs '("~/repo" "~/Downloads"))
  :bind (([remap shell-command] . dwim-shell-command)
         :map dired-mode-map
         ([remap dired-do-async-shell-command] . dwim-shell-command)
         ([remap dired-do-shell-command] . dwim-shell-command)
         ([remap dired-smart-shell-command] . dwim-shell-command))
  :config
  (require 'dwim-shell-commands))

(use-package transient :ensure t)
(use-package gptel
  :custom
  (gptel-default-mode #'org-mode)
  :bind
  (("C-c a p" . gptel)
   ("C-c a r" . gptel-rewrite)
   ("C-c a a" . gptel-add)
   ("C-c a f" . gptel-add-file)
   ("C-c C-RET" . gptel-send)
   ("C-c a m" . gptel-menu))
  :config
  (gptel-make-openai "OpenRouter"             
    :host "openrouter.ai"
    :endpoint "/api/v1/chat/completions"
    :key #'gptel-api-key-from-auth-source         
    :stream t
    :models '(deepseek/deepseek-v4-flash:free
              baidu/cobuddy:free
              poolside/laguna-xs.2:free
              nvidia/nemotron-3-super-120b-a12b:free
              nvidia/nemotron-3-nano-omni-30b-a3b-reasoning:free))

  (setq gptel-backend (gptel-get-backend "OpenRouter"))
  (setq gptel-model 'deepseek/deepseek-v4-flash:free))

(use-package gptel-agent
  :ensure ( :host github :repo "karthink/gptel-agent")
  
  :config (gptel-agent-update))         

(use-package ob-gptel
  :ensure (:host github :repo "jwiegley/ob-gptel")
  :config
  (add-to-list 'org-babel-load-languages '(gptel . t))
  (add-hook 'completion-at-point-functions
            'ob-gptel-capf nil t)) 

(use-package gptel-prompts
  :ensure (:host github :repo "jwiegley/gptel-prompts")
  :after (gptel)
  :demand t
  :custom
  (gptel-prompts-directory "~/config/prompts")
  :config
  (gptel-prompts-update)
  ;; Ensure prompts are updated if prompt files change
  ;; (gptel-prompts-add-update-watchers)
  )

(use-package agent-shell
  :bind
  ("C-c a s" . agent-shell)
  :custom
  ;; BUG https://github.com/niri-wm/niri/issues/2664
  (agent-shell-screenshot-command '("niri" "msg" "action" "screenshot" "--path"))
  ;; (agent-shell-opencode-default-model-id "openrouter/poolside/laguna-xs.2:free")
  (agent-shell-opencode-default-model-id "opencode/mimo-v2.5-free")
  :config
  ;; Evil state-specific RET behavior: insert mode = newline, normal mode = send
  (general-define-key
   :keymaps 'agent-shell-mode-map
   :states 'insert
   "RET" #'newline
   "TAB" nil
   :states 'normal
   "RET" #'comint-send-input
   "TAB" nil)

  
  ;; Configure *agent-shell-diff* buffers to start in Emacs state
  (add-hook 'diff-mode-hook
	        (lambda ()
	          (when (string-match-p "\\*agent-shell-diff\\*" (buffer-name))
		        (evil-emacs-state)))))

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
  ("C-c e" . notmuch)
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
          ( :name "💬 all unread (inbox)"
            :query "tag:unread and tag:inbox"
            :sort-order newest-first
            :key ,(kbd "u"))
          ;; ( :name "🔮 unread crypto"
          ;;   :query "tag:unread and tag:crypto"
          ;;   :sort-order newest-first
          ;;   :key ,(kbd "c"))
          ;; ( :name "🌞 unread life"
          ;;   :query "tag:unread and tag:life"
          ;;   :sort-order newest-first
          ;;   :key ,(kbd "l"))
		  )))


(setq browse-url-browser-function 'browse-url-generic
      browse-url-generic-program "librewolf")

(provide 'zfc-tool)
