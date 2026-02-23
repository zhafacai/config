(define-module (zfc home packages rime-ice)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix build-system copy)
  #:use-module ((guix licenses) #:prefix license:)
  #:export (rime-ice))

(define rime-ice
  (package
   (name "rime-ice")
   (version "master")
   (source (origin
	    (method git-fetch)
	    (uri (git-reference
		  (url "https://github.com/iDvel/rime-ice")
		  (commit "23f0c39a0b443524e37dbff4f085236b32691291")))
	    (sha256
	     (base32 "0jfdw277z5cynb906i2m24iasgj3an7r1gsrbx3hy9gymm9yvbv3"))))
   (build-system copy-build-system)
   (arguments
    '(#:install-plan '(("." "share/rime-data" #:exclude ("README.md" "LICENSE")))))
   (home-page "https://github.com")
   (synopsis "Rime 雾凇拼音")
   (description "Rime 配置：雾凇拼音 | 长期维护的简体词库 ")
   (license license:gpl3+)))
