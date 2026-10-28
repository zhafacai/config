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
  #:use-module (gnu packages emacs-xyz)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages pdf))


(define-public emacs-gptel-preset-collection
  (let ((commit "38651c2baf849e930e4f75b121df513989443898")
        (revision "1"))
    (package
      (name "emacs-gptel-preset-collection")
      (version (git-version "0.0.1" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
                (url "https://github.com/karthink/gptel-preset-collection")
                (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "16wpm9arrw18b1j1lbxbvp7p76q4rask829m260bz1yxf55p5a3d"))))
      (build-system emacs-build-system)
      (arguments
       (list #:tests? #f))
      (propagated-inputs (list emacs-gptel))
      (home-page "https://github.com/karthink/gptel-preset-collection")
      (synopsis
       "Presets Collections for gptel.")
      (description
       "A collection of presets for gptel.")
      (license license:gpl3+))))


(define-public emacs-gptel-inline
  (let ((commit "7a74fda2ed420c5967437f80c4eeb5a7d52a6314")
        (revision "1"))
    (package
      (name "emacs-gptel-inline")
      (version (git-version "0.0.1" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
                (url "https://github.com/karthink/gptel-inline")
                (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "14mzkvzr4d96pmz2iia48l00lmfqh2325slmxk82dngvnsml9bmr"))))
      (build-system emacs-build-system)
      (arguments
       (list #:tests? #f))
      (propagated-inputs (list emacs-gptel))
      (home-page "https://github.com/karthink/gpt-inline")
      (synopsis
       "A command to interact with a persistent gptel session from anywhere in Emacs.")
      (description
       "A command to interact with a persistent gptel session from anywhere in Emacs.")
      (license license:gpl3+))))


(define-public emacs-gptel-annotate
  (let ((commit "ec65d175b7a1b83fa6f256f5454b2e5f082b4841")
        (revision "1"))
    (package
      (name "emacs-gptel-annotate")
      (version (git-version "0.0.1" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
                (url "https://github.com/karthink/gptel-annotate")
                (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "1k7x6v1y7fzz8ad5z36qyy6njyw65gzwa7i5hvqcv7r4f36avdfn"))))
      (build-system emacs-build-system)
      (arguments
       (list #:tests? #f))
      (propagated-inputs (list emacs-gptel))
      (home-page "https://github.com/karthink/gpt-inline")
      (synopsis
       "Annotate files and buffers with LLM responses.")
      (description
       "Annotate files and buffers with LLM responses.")
      (license license:gpl3+))))
