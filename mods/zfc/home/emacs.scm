(define-module (zfc home emacs)
  #:use-module (gnu services)
  #:use-module (gnu home)
  #:use-module (gnu home services)
  #:use-module (gnu home services shepherd)
  #:use-module (guix gexp)
  #:use-module (guix build utils)
  #:use-module (gnu packages mail)
  #:use-module (gnu packages bash)
  #:use-module (sops secrets)
  #:use-module (sops home services sops)
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
    (append (list
             ;; this is too aggressive
             ;; %zfc-emacs-config-files
             (simple-service 'emacs-editor
                             home-environment-variables-service-type
                             `(("EDITOR" . "emacsclient"))))
            (list
             (simple-service 'git-gpg-config
                             home-files-service-type
                             (list `(".gitconfig"
                                     ,(local-file "../../../files/plain/gitconfig"))))
             (simple-service 'jj-gpg-config
                             home-files-service-type
                             (list `(".config/jj/config.toml"
                                     ,(local-file "../../../files/plain/jj.toml"))))
             (simple-service 'mbsync-config-service
                             home-files-service-type
                             (list
                              `(".mbsyncrc"
                                ,(local-file "../../../files/plain/mbsyncrc"))))
             (simple-service 'mbsync-gmail-timer-service
                             home-shepherd-service-type
                             (list
                              (shepherd-timer
                               '(mbsync-gmail)
                               "0 12 * * *"
                               #~(#$(file-append bash "/bin/bash")
                                  #$(mixed-text-file
                                     "mbsync-gmail"
                                     "set -e\n"
                                     "export NOTMUCH_DATABASE=\"${NOTMUCH_DATABASE:-$HOME/Documents/Mail}\"\n"
                                     (file-append isync "/bin/mbsync") " gmail\n"
                                     (file-append notmuch "/bin/notmuch") " new\n"
                                     (file-append bash "/bin/bash") " " (local-file "../../../files/plain/notmuch-tag-new") "\n"))
                               #:documentation "Synchronize Gmail via mbsync, index it with notmuch and apply the tagging rules, daily at noon.")))
             (simple-service 'notmuch-config-service
                             home-files-service-type
                             (list
                              `(".config/notmuch/default/config"
                                ,(mixed-text-file "notmuch-config"
                                                  "[user]\n"
                                                  "primary_email=zhafacai@gmail.com\n"))))
             (simple-service 'notmuch-env-service
                             home-environment-variables-service-type
                             `(("NOTMUCH_DATABASE" . ,(string-append (getenv "HOME") "/Documents/Mail"))))
             
             
             (service home-sops-secrets-service-type
                      (home-sops-service-configuration
                       (gnupg-home (in-vicinity (getenv "XDG_CONFIG_HOME") "sops"))
                       (verbose? #t)
                       (secrets
                        (list
                         (sops-secret
                          (key '("data"))
                          (path "/run/user/1000/secrets/elfeed.org")
                          (output-type "binary")
                          (file (local-file "../../../secrets/elfeed.org"))
                          (permissions #o400)))))))))))

zfc-emacs-home
