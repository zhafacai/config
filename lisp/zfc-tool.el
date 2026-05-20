(use-package org
  :ensure nil
  :bind
  ("C-c l" . org-store-link)
  ("C-c o" . org-open-at-point-global)
  :custom
  ;; org-default-notes-file (concat org-directory "notes.org")
  ;; org-clock-in-switch-to-state "DOING"
  ;; org-clock-out-when-done '("DONE" "CANCEL" "WAIT")
  ;; org-agenda-files `(,org-default-notes-file)
  ;; org-agenda-start-with-log-mode t
  (org-M-RET-may-split-line '((default . nil)))
  (org-insert-heading-respect-content t)
  (org-log-done 'time)
  (org-log-into-drawer t)
  (org-tags-column -100)
  (org-todo-keywords
   '((sequence "TODO(t)" "NEXT(n)" "WAIT(w@/!)" "|" "DONE(d!)" "CNCL(c@)")))
  (org-todo-keyword-faces
   '(("TODO"   . org-todo)
     ("NEXT"   . +org-todo-active)
     ("WAIT"   . +org-todo-onhold)
     ("DONE"   . org-done)
     ("CNCL" . +org-todo-cancel)))
  (org-tag-alist
   '(("@work" . ?w)
     ("@life" . ?l)))
  (org-agenda-window-setup 'only-window)
  (org-directory (file-truename "~/share/notes/eorg/"))
  (org-agenda-restore-windows-after-quit t)
  (org-startup-with-inline-images t)
  (org-startup-indented t)
  (org-src-preserve-indentation nil)
  (org-edit-src-content-indentation 0))
;; :config
;; (advice-add 'org-agenda-todo :after (lambda (&rest _) (org-save-all-org-buffers))))
(use-package mixed-pitch
  :hook
  (org-mode . mixed-pitch-mode))

(use-package org-tree-slide
  :after evil
  :config
  (fc/map :keymaps 'org-tree-slide-mode-map
    "j" #'org-tree-slide-move-next-tree
    "k" #'org-tree-slide-move-previous-tree))

(use-package valign
  :hook
  (org-mode . valign-mode))

(use-package org-modern
  :custom
  (org-modern-hide-stars nil)
  (org-modern-star '("◉" "○" "◈" "◇"))
  (org-modern-block-name nil)
  :hook
  (org-mode . org-modern-mode)
  (org-agenda-finalize . org-modern-agenda))

(use-package org-appear
  :hook
  (org-mode . org-appear-mode))

(use-package org-modern-indent
  :ensure (:host github :repo "jdtsmith/org-modern-indent")
  :config
  (add-hook 'org-mode-hook #'org-modern-indent-mode 90))

(use-package org-contrib
  :init
  (setq org-eldoc-breadcrumb-separator " → ")
  :hook (org-mode . org-eldoc-load))
(setq eldoc-documentation-strategy #'eldoc-documentation-compose-eagerly)

(use-package denote
  :hook
  ((text-mode . denote-fontify-links-mode-maybe)
   (dired-mode . denote-dired-mode))
  :bind
  (("C-c n n" . denote)
   ("C-c n d" . denote-dired)
   ("C-c n l" . denote-link)
   ("C-c n L" . denote-add-links)
   ("C-c n b" . denote-backlinks)
   ("C-c n q c" . denote-query-contents-link)
   ("C-c n q f" . denote-query-filenames-link)
   ("C-c n r" . denote-rename-file)
   ("C-c n R" . denote-rename-file-using-front-matter)
   :map dired-mode-map
   ("C-c C-d C-i" . denote-dired-link-marked-notes)
   ("C-c C-d C-r" . denote-dired-rename-files)
   ("C-c C-d C-k" . denote-dired-rename-marked-files-with-keywords)
   ("C-c C-d C-R" . denote-dired-rename-marked-files-using-front-matter))
  :config
  (setq denote-directory (concat org-directory "denote"))
  (setq denote-save-buffers nil)
  (setq denote-known-keywords '("emacs" "linux" "hack" "trade"))
  (setq denote-infer-keywords t)
  (setq denote-sort-keywords t)
  (setq denote-prompts '(title keywords))
  (setq denote-excluded-directories-regexp nil)
  (setq denote-keywords-to-not-infer-regexp nil)
  (setq denote-rename-confirmations '(rewrite-front-matter modify-file-name))
  (setq denote-date-prompt-use-org-read-date t)
  (denote-rename-buffer-mode 1))

(use-package denote-org
  :after denote
  :bind (:map org-mode-map
              ("C-c n o e" . denote-org-extract-org-subtree)
              ("C-c n o h" . denote-org-link-to-heading)
              ("C-c n o H" . denote-org-backlinks-for-heading)
              ("C-c n o f" . denote-org-convert-links-to-file-type)
              ("C-c n o d" . denote-org-convert-links-to-denote-type)
              ("C-c n o i" . denote-org-dblock-insert-files)
              ("C-c n o l" . denote-org-dblock-insert-links)
              ("C-c n o b" . denote-org-dblock-insert-backlinks)
              ("C-c n o m" . denote-org-dblock-insert-missing-links)
              ("C-c n o a" . denote-org-dblock-insert-files-as-headings)))

(use-package denote-journal
  :bind
  ("C-c n j" . denote-journal-new-or-existing-entry)
  :hook (calendar-mode . denote-journal-calendar-mode)
  :config
  ;; Use the "journal" subdirectory of the `denote-directory'.  Set this
  ;; to nil to use the `denote-directory' instead.
  (setq denote-journal-directory
        (expand-file-name "journal" denote-directory))
  ;; Default keyword for new journal entries. It can also be a list of
  ;; strings.
  (setq denote-journal-keyword "journal")
  ;; Read the doc string of `denote-journal-title-format'.
  (setq denote-journal-title-format 'day-date-month-year))

(use-package denote-sequence
  :after denote
  :bind (("C-c n s s" . denote-sequence)
         ("C-c n s f" . denote-sequence-find)
         ("C-c n s l" . denote-sequence-link)
         ("C-c n s d" . denote-sequence-dired)
         ("C-c n s r" . denote-sequence-reparent)
         ("C-c n s c" . denote-sequence-convert)))

(use-package consult-denote
  :bind (("C-c n f" . consult-denote-find)
         ("C-c n g" . consult-denote-grep))
  :config
  (consult-denote-mode 1))

(use-package org-gtd
  :after (org transient)
  :demand t
  :init
  ;; Suppress upgrade warnings (must be set before package loads)
  (setq org-gtd-update-ack "4.0.0")
  ;; Set GTD directory before package loads
  (setq org-gtd-directory (concat org-directory "gtd"))

  :custom
  (org-gtd-keyword-mapping '((todo . "TODO")
                             (next . "NEXT")
                             (wait . "WAIT")
                             (done . "DONE")
                             (canceled . "CNCL")))
  ;; Enable per-type refile prompting (recommended)
  ;; Without this, all items auto-refile to first target without prompting
  (org-gtd-refile-to-any-target nil)
  (org-gtd-save-after-organize t)

  :config
  (org-edna-mode)
  ;; Add org-gtd files to your agenda (in :config so org-gtd-directory is defined)
  (setq org-agenda-files (list org-gtd-directory))
  :bind
  ;; Global keybindings (work anywhere in Emacs)
  (("C-c d c" . org-gtd-capture)
   ("C-c d e" . org-gtd-engage)
   ("C-c d p" . org-gtd-process-inbox)
   ("C-c d n" . org-gtd-show-all-next)
   ("C-c d s" . org-gtd-reflect-stuck-projects)

   ;; Keybinding for organizing items (only works in clarify buffers)
   :map org-gtd-clarify-mode-map
   ("C-c c" . org-gtd-organize)

   ;; Quick actions on tasks in agenda views (optional but recommended)
   :map org-agenda-mode-map
   ("C-c ." . org-gtd-agenda-transient)))

(defun fc/org-insert-link-dwim ()
  "Like `org-insert-link' but with personal dwim preferences."
  (interactive)
  (let* ((point-in-link (org-in-regexp org-link-any-re 1))
         (clipboard-url (when (string-match-p "^http" (current-kill 0))
                          (current-kill 0)))
         (region-content (when (region-active-p)
                           (buffer-substring-no-properties (region-beginning)
                                                           (region-end)))))
    (cond ((and region-content clipboard-url (not point-in-link))
           (delete-region (region-beginning) (region-end))
           (insert (org-make-link-string clipboard-url region-content)))
          ((and clipboard-url (not point-in-link))
           (insert (org-make-link-string
                    clipboard-url
                    (read-string "title: "
                                 (with-current-buffer (url-retrieve-synchronously clipboard-url)
                                   (dom-text (car
                                              (dom-by-tag (libxml-parse-html-region
                                                           (point-min)
                                                           (point-max))
                                                          'title))))))))
          (t
           (call-interactively 'org-insert-link)))))

(with-eval-after-load 'org
  (evil-define-key 'normal org-mode-map
    (kbd "C-c C-l") #'fc/org-insert-link-dwim))

(provide 'zfc-org)

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

(use-package transient)
(use-package magit
  :config
  (add-hook 'magit-process-find-password-functions 'magit-process-password-auth-source)
  :custom
  (magit-display-buffer-function #'magit-display-buffer-fullframe-status-v1)
  :hook
  (git-commit-mode . evil-insert-state)
  :defer t)

(fc/map 'normal "gg" #'magit)

(defun fc/diff-hl-update-colors (&rest _)
  "Dynamically apply the current theme's standard diff colors to diff-hl faces.
   Sets both background and foreground to create a solid fringe block."
  (let ((added   (face-attribute 'diff-added :foreground nil 'default))
        (changed (face-attribute 'diff-changed :foreground nil 'default))
        (removed (face-attribute 'diff-removed :foreground nil 'default)))
    (custom-set-faces
     ;; Added lines: Inherit current theme's 'Added' color
     `(diff-hl-insert ((t (:inherit diff-added :background ,added :foreground ,added))))
     ;; Changed lines: Inherit current theme's 'Changed' color
     `(diff-hl-change ((t (:inherit diff-changed :background ,changed :foreground ,changed))))
     ;; Deleted lines: Inherit current theme's 'Removed' color
     `(diff-hl-delete ((t (:inherit diff-removed :background ,removed :foreground ,removed)))))))

(add-hook 'enable-theme-functions #'fc/diff-hl-update-colors)

(fc/diff-hl-update-colors)

(use-package diff-hl
  :init
  (global-diff-hl-mode)
  :config
  (add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh))
(evil-global-set-key 'normal (kbd "]h") #'diff-hl-next-hunk)
(evil-global-set-key 'normal (kbd "[h") #'diff-hl-previous-hunk)

(use-package browse-at-remote
  :config
  (fc/map 'normal "gb" #'browse-at-remote))

(use-package forge
  :after magit
  :custom
  (forge-add-default-bindings nil))

(use-package git-timemachine
  :after transient
  :config
  (fc/map 'normal "gt" #'git-timemachine))

(use-package git-modes)

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

(use-package gt
  :commands (gt-translate)
  :config
  (evil-define-key 'normal 'global [down-mouse-3] 'gt-translate)
  (fc/map 'normal "l" 'gt-translate)
  (setq gt-langs '(en zh))
  (setq gt-default-translator
        (gt-translator :engines (gt-stardict-engine
                                 :dir "~/.stardict/dic"
                                 :exact nil))))

(use-package ghostel
  :ensure t)

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

  (general-define-key
    "C-c m SPC" #'emms-pause
    "C-c m p" #'emms-previous
    "C-c m n" #'emms-next
    "C-c m s" #'emms-stop
    "C-c m m" #'emms
    "C-c m =" #'emms-volume-raise
    "C-c m -" #'emms-volume-lower)

  (setq emms-volume-change-function 'emms-volume-pulse-change)

  (evil-define-key 'normal emms-playlist-mode-map
    "s" #'emms-sort
    "q" #'emms-playlist-mode-bury-buffer))

(use-package nov
  :config
  (add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode)))

(use-package dwim-shell-command
  :custom
  (dwim-shell-commands-git-clone-dirs '("~/dev" "~/Downloads"))
  :bind (([remap shell-command] . dwim-shell-command)
         :map dired-mode-map
         ([remap dired-do-async-shell-command] . dwim-shell-command)
         ([remap dired-do-shell-command] . dwim-shell-command)
         ([remap dired-smart-shell-command] . dwim-shell-command))
  :config
  (require 'dwim-shell-commands))

(use-package gptel
  :bind
  (("C-c a p" . gptel)
   ("C-c a r" . gptel-rewrite)
   ("C-c a m" . gptel-menu))
  :config
  (gptel-make-openai "OpenRouter"             
    :host "openrouter.ai"
    :endpoint "/api/v1/chat/completions"
    :key #'gptel-api-key-from-auth-source         
    :stream t
    :models '(qwen/qwen3.6-plus-preview:free
              google/gemini-pro))

  (gptel-make-openai "OpenCode"
    :host "opencode.ai"
    :endpoint "/zen/v1/chat/completions"            
    :stream t                                      
    :key #'gptel-api-key-from-auth-source         
    :models '((minimax-m2.5-free
               :description "minimax"
               :capabilities (tool-use json)
               :context-window 200
               :input-cost 0.0
               :output-cost 0.0)
		      (big-pickle
               :description "Big Pickle model"
               :capabilities (tool-use json)
               :context-window 200
               :input-cost 0.0
               :output-cost 0.0)))

  (gptel-make-openai "BaiLian"
    :host "dashscope.aliyuncs.com"
    :endpoint "/compatible-mode/v1/chat/completions"            
    :stream t                                      
    :key #'gptel-api-key-from-auth-source         
    ;; :key (auth-source-pick-first-password :host "api.aliyuncs.com")
    :models '((qwen3.5-flash
               :description "qwen3.5-flash"
               :capabilities (tool-use json)
               :context-window 200
               :input-cost 0.0
               :output-cost 0.0)
              (kimi-k2.5
               :description "kimi-k2.5"
               :capabilities (tool-use json)
               :context-window 200
               :input-cost 0.0
               :output-cost 0.0)
              (qwen3.5-plus
               :description "qwen3.5-plus"
               :capabilities (tool-use json)
               :context-window 200
               :input-cost 0.0
               :output-cost 0.0)
              (MiniMax-M25
               :description "MiniMax-M2.5"
               :capabilities (tool-use json)
               :context-window 200
               :input-cost 0.0
               :output-cost 0.0)))
  (setq gptel-backend (gptel-get-backend "OpenRouter"))
  (setq gptel-default-mode #'org-mode)
  (setq gptel-model 'qwen/qwen3.6-plus-preview:free))

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
  :custom
  ;; BUG https://github.com/niri-wm/niri/issues/2664
  (agent-shell-screenshot-command '("niri" "msg" "action" "screenshot" "--path"))
  (agent-shell-opencode-default-model-id "openrouter/qwen/qwen3.6-plus-preview:free")
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

(general-define-key "C-c a s" #'agent-shell)

(setq epg-pinentry-mode 'loopback)

(use-package elfeed
  :bind
  ("C-c f" . elfeed))
(use-package elfeed-org
  :custom
  (rmh-elfeed-org-files '("/run/user/1000/secrets/elfeed"))
  :config
  (elfeed-org))

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

(provide 'zfc-tool)
