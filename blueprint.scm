(use-modules
 (blue subprocess)
 (blue types blueprint)
 (blue types command))

(define* ($guix #:key (channels "channels.lock"))
  (popen "guix" `("time-machine" "-C" ,channels "--" "shell" "-m" "manifest.scm")))

(define-command (build-command args)
  ((invoke "build")
   (category 'misc)
   (synopsis "Print build")
   (help "
  Print build on the terminal and exit.
  "))
  ($guix))

(blueprint
 (commands
  (list build-command)))
