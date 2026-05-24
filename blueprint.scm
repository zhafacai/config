(use-modules
 (srfi srfi-2)
 (blue computation)
 (blue subprocess)
 (blue types blueprint)
 (blue types command)
 (blue types configuration)
 (blue types variable))

(define ($ prog . args)
  (popen prog args))

(define-command (update-guix-command args)
  ((invoke "udg")
   (category 'system)
   (synopsis "Update guix channel")
   (help "
  Update guix channels.
  "))
  ($ "guix" "pull" "-C" "channels.scm")
  (system "guix describe -f channels > channels.lock")
  ;; (with-output-to-file "channels.tmp"
  ;; 	(lambda ()
  ;; 	  ($ "guix" "describe" "-f" "channels")))
  )

(define-command (upgrade-home-command args)
  ((invoke "ugh")
   (category 'system)
   (synopsis "Upgrade guix home")
   (help "
  Upgrade guix home.
  "))
  ($ "guix" "time-machine" "-C" "channels.lock" "--"
     "home" "reconfigure" "mods/zfc/system/art.scm" "-L" "mods"))

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
			 (file-path (format #f "secrets/~a.yaml" file)))
    
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
