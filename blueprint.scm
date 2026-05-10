(use-modules
 (blue subprocess)
 (blue types blueprint)
 (blue types command))

(define ($ prog . args)
  (popen prog args))

;; (define* ($update-guix #:key (channels "channels.lock"))
;;   ($ "guix" "time-machine" "-C" channels "--" "shell" "-m" "manifest.scm"))

(define-command (update-guix-command)
  ((invoke "update-guix")
   (category 'system)
   (synopsis "Update guix channel")
   (help "
  Update guix channels.
  "))
  ($ "guix" "pull" "-C" "channels.scm"))

(define-command (upgrade-guix-command args)
  ((invoke "upgrade-guix")
   (category 'system)
   (synopsis "Upgrade guix system")
   (help "
  Upgrade guix system.
  "))
  ($ "guix" "describe" "-f" "channels" ">" "channels.lock")
  ($ "sudo" "guix" "time-machine" "-C" "channels.lock" "--"
     "system" "reconfigure" "mods/zfc/system/art.scm" "-L" "mods"))

(define-command (update-nix-command)
  ((invoke "update-nix")
   (category 'system)
   (synopsis "Update nix flake")
   (help "
  Update nix flakes.
  "))
  ($ "nix" "flake" "update"))

(define-command (upgrade-nix-command)
  ((invoke "upgrade-nix")
   (category 'system)
   (synopsis "Upgrade nix flake")
   (help "
  Upgrade nix flakes.
  "))
  ($ "nix" "profile" "upgrade" "config"))

(blueprint
 (commands
  (list update-guix-command
        update-nix-command
        upgrade-guix-command
        upgrade-nix-command)))
