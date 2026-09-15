;;; -*- lexical-binding: t -*-
(use-package org
  :ensure nil
  :bind
  ("C-c c" . org-capture)
  ("C-c C-a" . org-agenda)
  (:map text-mode-map
        ("C-c l" . org-store-link))
  (:map org-mode-map
        ("C-c A" . org-attach)
        ("C-c C-a" . org-agenda)
        ("C-c C-M-l" . org-toggle-link-display))
  ;; ("C-c o" . org-open-at-point-global)
  :custom
  ;; org-default-notes-file (concat org-directory "notes.org")
  ;; org-clock-in-switch-to-state "DOING"
  ;; org-clock-out-when-done '("DONE" "CANCEL" "WAIT")
  ;; org-agenda-files `(,org-default-notes-file)
  ;; org-agenda-start-with-log-mode t
  (org-attach-directory "orgments/")
  (org-confirm-babel-evaluate nil)

  (org-src-window-setup 'current-window)
  (org-src-preserve-indentation t)

  (org-M-RET-may-split-line '((default . nil)))
  (org-insert-heading-respect-content t)
  (org-log-done 'time)
  (org-log-into-drawer t)
  (org-tags-column 0)
  (org-todo-keywords
   '((sequence "TODO(t)" "NEXT(n)" "WAIT(w@/!)" "|" "DONE(d!)" "CNCL(c@)")))
  (org-todo-keyword-faces
   '(("TODO"   . org-todo)
     ("NEXT"   . +org-todo-active)
     ("WAIT"   . +org-todo-onhold)
     ("DONE"   . org-done)
     ("CNCL" . +org-todo-cancel)))
  (org-agenda-window-setup 'only-window)
  (org-directory (file-truename "~/Documents/org/agenda/"))
  (org-default-notes-file (concat org-directory "task.org"))
  (org-agenda-files (list org-directory))
  (org-refile-targets
   '((org-agenda-files :maxlevel . 3)))
  (org-agenda-restore-windows-after-quit t)
  (org-startup-with-inline-images t)
  (org-startup-indented t)
  (org-edit-src-content-indentation 0))


(use-package org-tree-slide)

;; org-capture-templates
(use-package org
  :ensure nil
  :config
  (let ((with-time (concat ":PROPERTIES:\n"
                           ":CAPTURED: %U\n"
                           ":END:\n\n"
                           "%a\n%?")))
    (setq org-capture-templates `(("t" "Task" entry
                                   (file "task.org")
                                   ,(concat "* TODO %^{Title}\n" with-time)
                                   :prepend t
                                   :empty-lines-after 1)
                                  ("d" "Task with deadline" entry
                                   (file "task.org")
                                   ,(concat "* TODO %^{Title}\n" "DEADLINE: %^t\n" with-time)
                                   :prepend t
                                   :empty-lines-after 1)
                                  ("s" "Task with schedule" entry
                                   (file "task.org")
                                   ,(concat "* TODO %^{Title}\n" "SCHEDULE: %^t\n" with-time)
                                   :prepend t
                                   :empty-lines-after 1))))
  (setq org-agenda-custom-commands '(
                                     ("d" "Tasks DONE is last week" todo "DONE"
                                      ((org-agenda-overriding-header "Tasks are DONE in the last week\n")
                                       (org-agenda-start-day "-7d")))
                                     ("t" "Tasks need to clarity" todo "TODO"
                                      ((org-agenda-overriding-header "Tasks to be clarify\n")))
                                     ("n" "Tasks to do" todo "NEXT"
                                      ((org-agenda-overriding-header "Tasks to be DONE\n")))
                                     ("w" "Tasks are waiting" todo "WAIT"
                                      ((org-agenda-overriding-header "Tasks to WAIT\n")))))
  )

(defmacro fc/ob-autoload (lang-list)
  "Create autoloads for languages in LANG-LIST."
  (declare (indent 1))
  `(progn
     ,@(mapcar
        (lambda (lang)
          (let ((name (symbol-name lang)))
            `(use-package ,(intern (concat "ob-" name))
               :ensure nil
               :autoload
               (,(intern (concat "org-babel-execute:" name))
                ,(intern (concat "org-babel-expand-body:" name))
                ,(intern (concat "org-babel-" name "-initiate-session"))))))
        (cadr lang-list))))

(fc/ob-autoload '(rust lua python shell))

(use-package ob-C
  :ensure nil
  :autoload
  (org-babel-execute:cpp
   org-babel-expand-body:cpp))

(use-package org-modern
  :after org
  :custom
  (org-modern-hide-stars nil)
  (org-modern-star '("◉" "○" "◈" "◇"))
  (org-modern-block-name nil)
  :config
  (global-org-modern-mode))

(use-package org-appear
  :hook
  (org-mode . org-appear-mode))

(use-package org-modern-indent
  :vc (:url "https://github.com/jdtsmith/org-modern-indent")
  :config
  (add-hook 'org-mode-hook #'org-modern-indent-mode 90))

(use-package org-contrib
  :init
  (setq org-eldoc-breadcrumb-separator " → ")
  :hook (org-mode . org-eldoc-load))


(use-package org-download
  :custom
  (org-download-method 'attach)
  :config
  (org-download-enable))

(use-package verb
  :after org
  :config
  (define-key org-mode-map (kbd "C-c C-r") verb-command-map)
  (add-to-list 'org-babel-load-languages '(verb . t)))

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
  :bind
  (:map org-mode-map
   ("C-c C-l" . fc/org-insert-link-dwim)))

(use-package denote
  :hook
  (text-mode . denote-fontify-links-mode-maybe)
  (dired-mode . denote-dired-mode)
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
  (setq denote-directory "~/Documents/org/notes")
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
  :hook
  (calendar-mode . denote-journal-calendar-mode)
  (ef-themes-post-load . fc/denote-journal-custom-faces)
  :config
  ;; Use the "journal" subdirectory of the `denote-directory'.  Set this
  ;; to nil to use the `denote-directory' instead.
  (setq denote-journal-directory
        (expand-file-name "journal" denote-directory))
  ;; Default keyword for new journal entries. It can also be a list of
  ;; strings.
  (setq denote-journal-keyword "journal")
  ;; Read the doc string of `denote-journal-title-format'.
  (setq denote-journal-title-format 'day-date-month-year)
  (defun fc/denote-journal-custom-faces ()
    (ef-themes-with-colors
      (custom-set-faces
       `(denote-journal-calendar
         ((t (:box (:line-width 1 :color ,fg-added))))))))
  (fc/denote-journal-custom-faces))

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

(use-package org-timegrid
  :vc (:url "https://github.com/Gleek/org-timegrid" :rev :newest)
  :commands (org-timegrid-week))

(use-package org-super-agenda
  :disabled
  :after org-agenda
  :config
  (setq org-super-agenda-groups
        '((:name "Scheduled" :time-grid t)
          (:name "Next" :todo "NEXT")
          (:name "Waiting" :todo "WAIT")
          (:name "Important" :priority "A")))
  (org-super-agenda-mode 1))

;; structured agenda searches: M-x org-ql-search / org-ql-view
(use-package org-ql)

;; countdown timers (Prot): M-x tmr
;; (use-package tmr)

(provide 'zfc-org)
