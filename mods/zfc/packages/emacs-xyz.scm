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


(define-public emacs-ibuffer-project
  (let ((commit "9002abd9cb4c8753fe4f6c522d9407b4d52e7873")
        (revision "1"))
    (package
      (name "emacs-ibuffer-project")
      (version (git-version "v2.1" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
                (url "https://github.com/muffinmad/emacs-ibuffer-project")
                (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "08164kv60r1mr0y9ha613w321xqnrsmdq9s3vfmjpmz4fm058bv6"))))
      (build-system emacs-build-system)
      (arguments
       (list #:tests? #f))
      (home-page "https://github.com/muffinmad/emacs-ibuffer-project")
      (synopsis
       "Group ibuffer's list by project.")
      (description
       "Group ibuffer's list by project.")
      (license license:unlicense))))

(define-public emacs-agent-shell-dashboard
  (let ((commit "e99436e78a2736c3eebdfd036d31f46b22214cde")
        (revision "1"))
    (package
      (name "emacs-agent-shell-dashboard")
      (version (git-version "0.0.1" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
                (url "https://github.com/wandersoncferreira/agent-shell-dashboard")
                (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "0zhnr3jz18xb72m88gsslzhxjikh0fsrqfy94ndcybgd5z16k845"))))
      (build-system emacs-build-system)
      (arguments
       (list #:tests? #f))
      (propagated-inputs (list emacs-agent-shell))
      (home-page "https://github.com/wandersoncferreira/agent-shell-dashboard")
      (synopsis
       "A dashboard for agent-shell.")
      (description
       "A dashboard for agent-shell.")
      (license license:expat-0))))

(define-public emacs-material-icons
  (let ((commit "230d44da047083faf3a90dc56ade06430ad49e7e")
        (revision "1"))
    (package
      (name "emacs-material-icons")
      (version (git-version "0.0.1" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
                (url "https://github.com/zHaOdANiuu/material-icons.el")
                (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "11plvjkjhqwlmmm57fy2r9mkam3rzm4q490g14rk3767da19lj0c"))))
      (build-system emacs-build-system)
      (arguments
       (list
        #:tests? #f
        #:include #~(cons "^icons/" %default-include)
        #:phases
        #~(modify-phases %standard-phases
            (add-after 'unpack 'unpack-icons
              (lambda _
                (invoke "tar" "-xzf" "icons.tar.gz")
                #t)))))
      (home-page "https://github.com/zHaOdANiuu/material-icons.el")
      (synopsis "Material icons for Emacs.")
      (description "Material icons for Emacs.")
      (license license:gpl3))))
