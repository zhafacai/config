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
    (inherit emacs-rime)
    (name "emacs-rime-zfc")
    (inputs
     (list librime rime-ice))))
