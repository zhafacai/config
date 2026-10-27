(define-module (zfc home packages rime-ice)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix build-system copy)
  #:use-module (guix build-system emacs)
  #:use-module (gnu packages emacs-build)
  #:use-module (gnu packages emacs-xyz)
  #:use-module (gnu packages ibus)
  #:use-module ((guix licenses) #:prefix license:)
  #:export (emacs-rime-zfc))

(define rime-ice
  (package
    (name "rime-ice")
    (version "2026.06.30")
    (source (origin
  	          (method git-fetch)
  	          (uri (git-reference
  		             (url "https://github.com/iDvel/rime-ice")
  		             (commit "6810e8916d160498620a16fef2135956fecbd485")))
  	          (sha256
  	           (base32 "1jvnwaaykr78917y4sl8mg8f2f1yn1z0354xm4hxmpx1i0aq25qx"))))
    (build-system copy-build-system)
    (arguments
     '(#:install-plan '(("." "share/rime-data" #:exclude ("README.md" "LICENSE")))))
    (home-page "https://github.com")
    (synopsis "Rime 雾凇拼音")
    (description "Rime 配置：雾凇拼音 | 长期维护的简体词库")
    (license license:gpl3+)))

(define-public emacs-rime-zfc
  (package
    (name "emacs-rime-zfc")
    (version "1.0.5")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
              (url "https://github.com/DogLooksGood/emacs-rime")
              (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0z0iwsqr92g8ykxb51gkawwxwzx0faw0027zgdi7c38ngjqld237"))))
    (build-system emacs-build-system)
    (arguments
     '(#:include (cons "\\.so$" %default-include)
       #:test-command (list "emacs" "--batch" "-l" "test.el")
       #:phases
       (modify-phases %standard-phases
         (add-after 'unpack 'patch-rime-data-path
           (lambda* (#:key inputs #:allow-other-keys)
             (make-file-writable "rime.el")
             (emacs-substitute-variables "rime.el"
               ("rime-share-data-dir"
                (search-input-directory inputs
                                        "share/rime-data")))))
         (add-before 'install 'build-emacs-module
           (lambda _
             (invoke "make" "lib")))
         (add-before 'check 'pre-check
           (lambda _
             (setenv "HOME" (getenv "TMPDIR"))
             (mkdir-p (string-append (getenv "HOME")
                                     "/.emacs.d/rime")))))))
    (inputs
     (list librime rime-ice))
    (propagated-inputs
     (list emacs-dash emacs-popup emacs-posframe))
    (home-page "https://github.com/DogLooksGood/emacs-rime")
    (synopsis "Rime input method in Emacs")
    (description
     "Rime is an Emacs input method built upon Rime input method engine.")
    (license license:gpl3+)))
