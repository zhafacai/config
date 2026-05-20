(defmacro after! (features &rest body)
  (declare (indent 1) (debug t))

  (unless (or (symbolp features) (consp features))
    (error "the first param of after! should be symbol or list."))

  (let ((fs (if (symbolp features)
                (list features)
              features))
        (form `(progn ,@body)))

    (dolist (f (reverse fs))
      (setq form `(with-eval-after-load ',f
                    ,form)))

    form))

(provide 'zfc-macro)
