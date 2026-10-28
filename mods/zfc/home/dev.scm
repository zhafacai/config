(define-module (zfc home dev)
  #:use-module (gnu packages)
  #:use-module (gnu services)
  #:use-module (gnu home)
  #:use-module (gnu home services)
  #:use-module (gnu home services shepherd)
  #:use-module (rosenthal packages emacs-xyz)
  #:use-module (zfc home packages rime-ice)
  #:use-module (zfc packages emacs-xyz)
  #:use-module (gnu packages shells)
  #:use-module (gnu home services shells)
  #:use-module (zfc config common)
  #:use-module (gnu packages mail)
  #:use-module (gnu packages bash)
  #:use-module (sops secrets)
  #:use-module (sops home services sops)
  #:use-module (bluebox packages blue)
  #:use-module (guix gexp)
  #:export (%zfc-dev-packages %zfc-dev-services))

;; NOTE: %zfc-dev-packages is deliberately a *function*: calling it (instead
;; of dereferencing a variable) keeps `specifications->packages' out of this
;; module's load.  A specs call during module load triggers the
;; package-module scan, which loads every module under the `-L' search
;; path; keeping the specs call out of load means no module can ever be
;; observed half-loaded, no matter who loads what.  Home assembly happens
;; in the caller (art.scm / blueprint `ugh').
(define (%zfc-dev-packages)
  (append
   (list
    emacs-rime-zfc
    emacs-gptel-preset-collection
    emacs-gptel-inline
    emacs-gptel-annotate
    blue
    )
   (specifications->packages (list
                              "emacs-pgtk"
                              ;; core
                              "ripgrep"
				              "fd"
                              "emacs-avy"
                              "emacs-expand-region"
                              "emacs-move-text"
                              "emacs-crux"
                              "emacs-mwim"
                              "emacs-undo-fu-session"
                              "emacs-vundo"
                              "emacs-multiple-cursors"
                              "emacs-modus-themes"
                              "emacs-ef-themes"
                              "emacs-spacious-padding"
                              "emacs-logos"
                              "emacs-olivetti"
                              "emacs-rainbow-mode"
                              "emacs-hl-todo"
                              "emacs-doom-modeline"
                              "emacs-pulsar"
                              "emacs-rainbow-delimiters"
                              "emacs-nyan-mode"
                              "emacs-lin"
                              "emacs-gcmh"
                              "emacs-wgrep"
                              "emacs-project-x"
                              "emacs-dired-preview"
                              
                              ;; ready-player
                              "mpv"
                              "ffmpeg"
                              "ffmpegthumbnailer"
                              
                              
                              "emacs-smartparens"
                              
                              "emacs-consult"
                              "emacs-consult-dir"
                              "emacs-helpful"
                              "emacs-elisp-demos"
                              "emacs-devdocs"
                              "emacs-vertico"
                              "emacs-orderless"
                              "emacs-marginalia"
                              "emacs-embark"
                              "emacs-ace-window"
                              "emacs-0x0"
                              
                              "emacs-corfu"
                              "emacs-nerd-icons-corfu"
                              "emacs-cape"
                              "emacs-tempel"
                              "emacs-tempel-collection"
                              "emacs-yasnippet"
                              "emacs-yasnippet-snippets"
                              "emacs-apheleia"
                              "emacs-consult-eglot"
                              "emacs-eldoc-box"
                              "emacs-flymake"
                              "emacs-dape"
                              
                              "emacs-jinx"
                              "hunspell"
                              "hunspell-dict-en-us"
                              
                              "emacs-eros"
                              "emacs-macrostep"
                              "emacs-inspector"
                              "emacs-org-tree-slide"
                              "emacs-org-modern"
                              "emacs-org-modern-indent"
                              "emacs-org-appear"
                              "emacs-org-contrib"
                              "emacs-org-download"
                              "emacs-denote"
                              "emacs-denote-org"
                              "emacs-denote-journal"
                              "emacs-denote-sequence"
                              "emacs-consult-denote"
                              "emacs-org-timegrid"
                              "emacs-org-ql"
                              ;; gt
                              "sdcv"
                              ;; notmuch
                              "notmuch"
                              "emacs-notmuch"
                              "emacs-ol-notmuch"
                              "emacs-notmuch-indicator"
                              "emacs-pass"
                              "isync"
                              "msmtp"
                              "openssl"
                              "nss-certs"
                              "password-store"
                              "emacs-nov"
                              "emacs-cal-china-x"
                              "emacs-elfeed"
                              "emacs-elfeed-tube"
                              "yt-dlp"
                              "emacs-elfeed-org"
                              "emacs-reader"
                              "emacs-telega"
                              "emacs-tracking"
                              "emacs-magit"
                              "emacs-majutsu-dolly"
                              "emacs-diff-hl"
                              "emacs-browse-at-remote"
                              "emacs-forge"
                              "emacs-git-modes"
                              
                              "wtype"
                              "emacs-guix"
                              "emacs-gt"
                              "emacs-tmr"
                              "emacs-sops"
                              "emacs-yaml-mode"
                              
                              "emacs-consult-ghostel"
                              "emacs-ben"
                              "direnv"
                              
                              "emacs-dwim-shell-command"
                              "emacs-gptel"
                              "emacs-gptel-agent"
                              "emacs-gptel-prompts"
                              "emacs-ob-gptel"
                              "emacs-gptel-quick"
                              "emacs-agent-shell"
                              "emacs-nix-ts-mode"
                              "emacs-cmake-mode"
                              "emacs-rustic"
                              "emacs-rust-mode"
                              "emacs-fennel-mode"
                              "emacs-kdl-mode"
                              "emacs-just-ts-mode"
                              "emacs-meson-mode"
                              ;; fish plugins
                              "starship"
                              "zoxide"
                              "fzf"
				              ))))

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
                     (secrets
                      (list
                       (sops-secret
                        (key '("data"))
                        (path "/run/user/1000/secrets/elfeed.org")
                        (output-type "binary")
                        (file (local-file "../../../secrets/elfeed.org"))
                        (permissions #o400))))))
           )))

;; `home-dev' is the *value* of this file: `guix home reconfigure
;; mods/zfc/home/dev.scm' evaluates the file and uses the last top-level
;; form's value as the home environment.  This is the deploy target for
;; non-Guix systems: ugh points here so the dev environment can be
;; recovered on another distro, while the Guix machine's own home is the
;; full base+dev assembly defined in art.scm.
(define (home-dev)
  (home-environment
   (packages
    (%zfc-dev-packages))
   (services
    %zfc-dev-services)))

(home-dev)
