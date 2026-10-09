(define-module (zfc packages emacs-xyz)
  #:use-module (guix packages)
  #:use-module (guix utils)
  #:use-module (guix gexp)
  #:use-module (guix git-download)
  #:use-module (guix download)
  #:use-module (guix build-system emacs)
  #:use-module ((guix licenses)
                #:prefix license:)

  #:use-module (gnu packages emacs)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages pdf)
  #:export (emacs-reader))


(define emacs-reader
  (package
   (name "emacs-reader")
   (version "master")
   (source
    (origin
     (method git-fetch)
     (uri (git-reference
           (url "https://codeberg.org/MonadicSheep/emacs-reader")
           (commit "d835fee5f86447ccd510d31aed0adc73c3011abd")))
     (file-name (git-file-name name version))
     (sha256
      (base32 "1xqhifwinwgs7f3lcg8hchnm8910n4sl77vssy9fyq51fm8nnax3"))))
   (build-system emacs-build-system)
   (arguments
    (list
     #:tests? #f ;no tests
     #:phases
     #~(modify-phases %standard-phases
					  (add-after 'expand-load-path 'build-module
								 (lambda* (#:key inputs #:allow-other-keys)
								   (invoke "make" "USE_PKGCONFIG=no"))) ; We don't need pkg-config
					  (add-after 'install 'install-module
								 (lambda* (#:key outputs #:allow-other-keys)
								   (let* ((out (assoc-ref outputs "out"))
										  (target-dir (string-append out
																	 "/share/emacs/site-lisp/" #$name "-" #$version)))
									 (install-file "render-core.so" target-dir)))))))

   (native-inputs (list mupdf gcc))
   (home-page "https://codeberg.org/divyaranjan/emacs-reader")
   (synopsis
    "An all-in-one document reader for all formats in Emacs, backed by MuPDF.")
   (description
    "An all-in-one document reader for GNU Emacs, supporting all major document formats.
This package intends to take from doc-view, nov.el, and pdf-tools and make them better.
And as such, it is effectively a drop-in replacement for them.")
   (license license:gpl3+)))

emacs-reader
