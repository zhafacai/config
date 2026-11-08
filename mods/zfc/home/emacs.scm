(define-module (zfc home emacs)
  #:use-module (gnu services)
  #:use-module (gnu home)
  #:use-module (gnu home services)
  #:use-module (guix gexp)
  #:use-module (zfc home packages emacs)
  #:export (%zfc-emacs-config-files zfc-emacs-home))

(define %zfc-emacs-config-files
  (service home-files-service-type
           `((".config/emacs/init.el"
              ,(local-file "../../../emacs/init.el"))
             (".config/emacs/early-init.el"
              ,(local-file "../../../emacs/early-init.el"))
             (".config/emacs/lisp"
              ,(local-file "../../../emacs/lisp" #:recursive? #t))
             (".config/emacs/templates"
              ,(local-file "../../../files/plain/emacs-templates")))))

(define zfc-emacs-home
  (home-environment
   (packages (%zfc-emacs-packages))
   (services
    (list %zfc-emacs-config-files
          (simple-service 'emacs-editor
                          home-environment-variables-service-type
                          `(("EDITOR" . "emacsclient")))))))

zfc-emacs-home
