((org-mode . ((eval . (progn
                        ;; auto tangle
                        (add-hook 'after-save-hook
                                  (lambda ()
                                    (let ((org-confirm-babel-evaluate nil))
                                      (org-babel-tangle)))
                                  nil t)
                        ;; turn on olivetti if it's dots.org
                        (when (and (buffer-file-name)
                                   (string= (file-name-nondirectory (buffer-file-name)) "dots.org"))
                          (olivetti-mode 1)))))))
