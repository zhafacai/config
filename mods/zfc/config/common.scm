(define-module (zfc config common))

;; Resolve the repository's `files' directory relative to this source file
;; (mods/zfc/config/common.scm -> <repo>/files) instead of the process working
;; directory captured at module-load time.  This makes `config-files-path'
;; stable no matter from which directory `guix system/home reconfigure' is
;; invoked (relative or absolute -L), and keeps working after the repo is
;; cloned to a different path.
(define-public %config-files-dir
  (let* ((source (or (search-path %load-path "zfc/config/common.scm")
                     (search-path %load-path "zfc/system/art.scm")
                     (error "zfc modules not found on %load-path (did you pass -L mods?)")))
         (config-dir (dirname (canonicalize-path source))))
    ;; config-dir = <repo>/mods/zfc/config ; repo files dir is 3 levels up.
    (string-append config-dir "/../../../files")))

(define-public (config-files-path path)
  (string-append %config-files-dir "/" path))
