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
  :general
  (:states 'normal :keymaps 'org-tree-slided-mode-map
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

(use-package org
  :ensure nil
  :general
  (:states 'normal :keymaps 'org-mode-map "C-c C-l" #'fc/org-insert-link-dwim))

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

  :general
  (general-nmap
    "SPC dc"  #'org-gtd-capture
    "SPC de"  #'org-gtd-engage
    "SPC dp"  #'org-gtd-process-inbox
    "SPC dn"  #'org-gtd-show-all-next
    "SPC ds"  #'org-gtd-reflect-stuck-projects)
  :bind
  (;; Keybinding for organizing items (only works in clarify buffers)
   :map org-gtd-clarify-mode-map
   ("C-c c" . org-gtd-organize)

   ;; Quick actions on tasks in agenda views (optional but recommended)
   :map org-agenda-mode-map
   ("C-c ." . org-gtd-agenda-transient)))

(provide 'zfc-org)
