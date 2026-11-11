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

(define-command (install-system-command args)
  ((invoke "ins")
   (category 'system)
   (synopsis "Install system")
   (help "
  Install Guix system.
  "))
  
  ($ "guix" "time-machine" "-C" "channels.lock" "--"
     "system" "init" "-L" "mods" "mods/zfc/system/art.scm"))

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
  
  ($ "guix" "time-machine" "-C" "channels.lock" "--"
     "home" "reconfigure" "-L" "mods" "mods/zfc/home/dev.scm"))

(define-command (upgrade-emacs-command args)
  ((invoke "ude")
   (category 'system)
   (synopsis "Deploy stand-alone Emacs environment")
   (help "
  Deploy the Emacs-only home environment: the full package set and the
  tangled config, with the config shipped from the store instead of
  symlinked to the repo.  Machine-bound services (input method, email sync,
  secrets, shell configs) are left out, so this is how to recover the editor
  on a fresh host.
  "))

  ($ "guix" "time-machine" "-C" "channels.lock" "--"
     "home" "reconfigure" "-L" "mods" "mods/zfc/home/emacs.scm"))

(define-command (upgrade-guix-command args)
  ((invoke "ugg")
   (category 'system)
   (synopsis "Upgrade guix system")
   (help "
  Upgrade guix system.
  "))
  
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

(define-command (build-emacs-packages-command args)
  ((invoke "bep")
   (category 'system)
   (synopsis "build emacs packages")
   (help "[EMACS_PACKAGE]
  Build emacs packages in mods."))
  
  (and-let* (((not (null? args)))
			 (name (car args))
			 (file-path (format #f "(@ (zfc packages emacs-xyz) ~a)" name)))
    
    ($ "guix" "build" "-e" file-path "-L" "mods")))

(blueprint
 (commands
  (list
   edit-sops-command
   build-emacs-packages-command
   update-nix-command
   update-guix-command
   upgrade-nix-command
   upgrade-home-command
   upgrade-emacs-command
   upgrade-guix-command)))
