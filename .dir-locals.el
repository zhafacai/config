((org-mode . ((eval . (add-hook 'after-save-hook
                                (lambda ()
                                  (let ((org-confirm-babel-evaluate nil))
                                    (org-babel-tangle)))
                                nil t)))))
