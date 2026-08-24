(define-module (zfc home dev)
  #:use-module (gnu packages)
  #:use-module (gnu services)
  #:use-module (gnu home)
  #:use-module (gnu home services)
  #:use-module (zfc packages emacs-xyz)
  #:use-module (gnu packages gnupg)
  #:use-module (gnu home services gnupg)
  #:use-module (gnu packages shells)
  #:use-module (gnu home services shells)
  #:use-module (gnu home services shepherd)
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
;; module's load.  A specs call during module load triggers the package-module
;; scan, which loads (zfc home base) from its file; base in turn consumes this
;; module, and a half-loaded module would fail with "unbound variable".
(define (%zfc-dev-packages)
  (append
   (list
    emacs-reader
    blue
    )
   (specifications->packages (list
                              "emacs-next-pgtk"
                              ;; core
                              "ripgrep"
				  "fd"
                              ;; ready-player
                              "mpv"
                              "ffmpeg"
                              "ffmpegthumbnailer"
                              ;; telega
                              "emacs-telega"
                              ;; magit-difftastic
                              "difftastic"
                              ;; rime
                              "emacs-rime"
                              ;; emacs-everywhere
                              "wtype"
                              ;; guix
                              "emacs-guix"
                              ;; gt
                              "sdcv"
                              ;; ben
                              "direnv"
                              ;; notmuch
                              "notmuch"
                              "emacs-notmuch"
                              "isync"
                              "msmtp"
                              "openssl"
                              "nss-certs"
                              ;; fish plugins
                              "starship"
                              "zoxide"
                              "fzf"
				  ))))

(define %zfc-dev-services
  (append (list
           (service home-gpg-agent-service-type
                    (home-gpg-agent-configuration
                     (pinentry-program (file-append pinentry-qt "/bin/pinentry-qt"))
                     (default-cache-ttl 1800)
                     (extra-content "allow-loopback-pinentry")
                     (ssh-support? #t)))
           (simple-service 'base-env-vars-service
                           home-environment-variables-service-type
                           `(("EDITOR" . "emacsclient")))
           (service home-fish-service-type
                    (home-fish-configuration
                      (config
                       (list (plain-file "fish_greeting.fish" "set -g fish_greeting")
                             (plain-file "plugins.fish" (string-append "starship init fish | source\n"
                                                                       "zoxide init fish | source\n"
           															"fish_config theme choose catppuccin-mocha\n"
                                                                       "direnv hook fish | source\n"
                                                                       ;; atuin takes C-r; up-arrow keeps default
                                                                       "atuin init fish --disable-up-arrow | source\n"))))))
           
           
           (simple-service 'fish-fisher-service
                           home-shepherd-service-type
                           (list
                            (shepherd-service
                             (provision '(fish-fisher))
                             (one-shot? #t)
                              ;; Resolve the plugins path at *configure* time (it is fixed
                              ;; once (zfc config common) loads) and splice it into the
                              ;; activation script with #$.  The script then needs no
                              ;; (use-modules (zfc config common)) and no load-path at
                              ;; activation time.  getenv calls get a HOME fallback.
                              (start
                               (let ((plugins (config-files-path "fish/fish_plugins")))
                                 #~(lambda ()
                                     (let* ((xdg (or (getenv "XDG_CONFIG_HOME")
                                                     (string-append (getenv "HOME") "/.config")))
                                            (source #$plugins)
                                            (target (string-append xdg "/fish/fish_plugins"))
                                            (fish-bin #$(file-append fish "/bin/fish")))
                                       (format #t "Directly symlinking fish_plugins (~a) to ~a~%" source target)
                                       (when (false-if-exception (lstat target))
                                         (delete-file target))
                                       (symlink source target)
                                       (unless (file-exists? (string-append xdg "/fish/functions/fisher.fish"))
                                         (format #t "Installing fisher~%")
                                         ;; Non-fatal: a fresh machine may be offline during
                                         ;; the first activation.
                                         (false-if-exception
                                          (system (string-append fish-bin " -c \"curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | "
                                                                 "source && fisher install jorgebucaran/fisher\""))))
                                       (format #t "Updating fisher plugins~%")
                                       ;; Non-fatal: don't fail the whole reconfigure when the
                                       ;; network is unavailable or a plugin can't be fetched.
                                       (unless (zero? (or (false-if-exception
                                                           (system (string-append fish-bin " -c \"fisher update\"")))
                                                          -1))
                                         (format #t "Warning: `fisher update' failed (network error?)~%"))
                                       #t))))
                             (documentation "Initialize and update Fish plugins via fisher."))))
           
             (simple-service 'cargo-config
             	home-files-service-type
               `(( ".cargo/config.toml" ,(local-file "../../../files/plain/cargo.toml"))))
             (simple-service 'git-gpg-config
                 home-files-service-type
               (list `(".gitconfig"
                       ,(local-file "../../../files/plain/gitconfig"))))
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
                     (gnupg-home (in-vicinity (getenv "XDG_DATA_HOME") "sops"))
                     (secrets
                      (list
                       (sops-secret
                        (key '("data"))
                        (path "/run/user/1000/secrets/elfeed.org")
                        (output-type "binary")
                        (file (local-file "../../../secrets/elfeed.org"))
                        (permissions #o400))))))
           )))

(define home-dev
  (home-environment
   (packages
    (%zfc-dev-packages))
   (services
    %zfc-dev-services)))

home-dev
