(use-modules
 (srfi srfi-2)
 (guix build utils)          ; invoke — propagates failures
 (blue computation)
 (blue subprocess)
 (blue types blueprint)
 (blue types command)
 (blue types configuration)
 (blue types variable))

(define ($ prog . args)
  (apply invoke prog args)
  #t)

(define-command (update-guix-command args)
  ((invoke "udg")
   (category 'system)
   (synopsis "Update guix channel")
   (help "
  Update guix channels.
  "))
  ($ "guix" "pull" "-C" "channels.scm")
  ;; `invoke' throws on a non-zero exit (unlike `popen'/`system'), so a failed
  ;; `guix pull' stops here instead of silently writing a stale channels.lock.
  (with-output-to-file "channels.lock"
    (lambda () (invoke "guix" "describe" "-f" "channels"))))

(define-command (upgrade-home-command args)
  ((invoke "ugh")
   (category 'system)
   (synopsis "Deploy dev home environment")
   (help "
  Deploy the dev home environment (dev-only, no Guix-specific base).
  Used to recover the dev environment on non-Guix systems.
  "))
  ;; Smoke test: lower the whole home first, fail fast before switching
  ;; generations (catches broken modules, empty tangles, bad derivations).
  ($ "guix" "time-machine" "-C" "channels.lock" "--"
     "home" "build" "--dry-run" "-L" "mods" "mods/zfc/home/dev.scm")
  ($ "guix" "time-machine" "-C" "channels.lock" "--"
     "home" "reconfigure" "-L" "mods" "mods/zfc/home/dev.scm"))

(define-command (upgrade-guix-command args)
  ((invoke "ugg")
   (category 'system)
   (synopsis "Upgrade guix system")
   (help "
  Upgrade guix system.
  "))
  ;; Smoke test: evaluate the OS derivation before switching generations.
  ($ "guix" "time-machine" "-C" "channels.lock" "--"
     "system" "build" "-d" "-L" "mods" "mods/zfc/system/art.scm")
  ($ "sudo" "-E" "guix" "time-machine" "-C" "channels.lock" "--"
     "system" "reconfigure" "mods/zfc/system/art.scm" "-L" "mods"))

(define-command (update-nix-command args)
  ((invoke "udn")
   (category 'system)
   (synopsis "Update nix flake")
   (help "
  Update nix flakes.
  "))
  ($ "nix" "flake" "update"))

(define-command (upgrade-nix-command args)
  ((invoke "ugn")
   (category 'system)
   (synopsis "Upgrade nix flake")
   (help "
  Upgrade nix flakes.
  "))
  ($ "nix" "profile" "upgrade" "config"))


(define-command (edit-sops-command args)
  ((invoke "eds")
   (category 'system)
   (synopsis "Edit sops encrypted file")
   (help "[FILE_PATH]
  Edit sops encrypted file using EDITOR."))
  
  (and-let* (((not (null? args)))
			 (file (car args))
			 (file-path (format #f "secrets/~a" file)))
    
    ($ "sops" "edit" file-path)))

(blueprint
 (commands
  (list
   edit-sops-command
   update-nix-command
   update-guix-command
   upgrade-nix-command
   upgrade-home-command
   upgrade-guix-command)))
