(define-module (zfc home dev)
  #:use-module (gnu packages)
  #:use-module (gnu services)
  #:use-module (gnu home)
  #:use-module (gnu home services)
  #:use-module (gnu home services shepherd)
  #:use-module (gnu packages shells)
  #:use-module (gnu home services shells)
  #:use-module (zfc config common)
  #:use-module (bluebox packages blue)
  #:use-module (guix gexp)
  #:use-module (zfc home packages emacs)
  #:export (%zfc-dev-packages %zfc-dev-services))

(define %zfc-dev-packages
  (append
   (list
    blue
    )
   ;; Core CLI tools unrelated to the Emacs set; everything Emacs needs
   ;; (its own packages plus the programs it shells out to) comes from
   ;; packages/emacs.scm.
   (specifications->packages (list
                              "ripgrep"
				              "fd"
				              ))
   (%zfc-emacs-packages)))

(define %zfc-dev-services
  (append (list
           (simple-service 'tempel-templates-service
                           home-files-service-type
                           `((".config/emacs/templates"
                              ,(local-file "../../../files/plain/emacs-templates"))))
           (simple-service 'base-env-vars-service
                           home-environment-variables-service-type
                           `(("EDITOR" . "emacsclient")))
           (service home-fish-service-type
                    (home-fish-configuration
                      (config
                       (list (plain-file "fish_greeting.fish" "set -g fish_greeting")
                             ;; (plain-file "gpg_nonguix.fish" "export SSH_AUTH_SOCK=$XDG_RUNTIME_DIR/gnupg/S.gpg-agent.ssh")
                             (plain-file "plugins.fish" (string-append "starship init fish | source\n"
                                                                       "zoxide init fish | source\n"
                                                                       ;; TODO refer to fish plugins in rosenthal
           															;; "fish_config theme choose catppuccin-mocha\n"
                                                                       "direnv hook fish | source\n"
                                                                       ;; atuin takes C-r; up-arrow keeps default
                                                                       "atuin init fish --disable-up-arrow | source\n"))))))
           
           
           (simple-service 'cargo-config
             	            home-files-service-type
                           `(( ".cargo/config.toml" ,(local-file "../../../files/plain/cargo.toml"))))
           )))

(define home-dev
  (home-environment
   (packages
    %zfc-dev-packages)
   (services
    %zfc-dev-services)))

home-dev
