  (define-module (zfc home packages rime-ice)
    #:use-module (guix packages)
    #:use-module (guix git-download)
    #:use-module (guix build-system copy)
    #:use-module ((guix licenses) #:prefix license:)
    #:export (rime-ice))

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
  	           (base32 "1wj9dhz46wka0rj72dz4y97rbihrzh1kbik8cjj74qwg0bcy07yx"))))
      (build-system copy-build-system)
      (arguments
       '(#:install-plan '(("." "share/rime-data" #:exclude ("README.md" "LICENSE")))))
      (home-page "https://github.com")
      (synopsis "Rime 雾凇拼音")
      (description "Rime 配置：雾凇拼音 | 长期维护的简体词库")
      (license license:gpl3+)))
