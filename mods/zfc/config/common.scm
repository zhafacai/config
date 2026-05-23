(define-module (zfc config common))

(define-public %config-files-dir
  ;; The cwd should be the repository root
  (string-append (getcwd) "/files"))

(define-public (config-files-path path)
  (string-append %config-files-dir "/" path))
