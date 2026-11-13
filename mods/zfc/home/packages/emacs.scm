(define-module (zfc home packages emacs)
  #:use-module (gnu packages)
  #:use-module (guix packages)
  #:use-module (srfi srfi-1)
  #:use-module (zfc packages emacs-xyz)
  #:use-module (zfc home packages rime-ice))

;; A dependency is either a channel package specification (a string) or, for a
;; package defined in this repository, the package variable itself: name
;; lookups only consult the channel package database, which knows nothing
;; about -L mods.
(define-public %zfc-emacs-deps
  (list
   "emacs-avy"
   "emacs-expand-region"
   "emacs-surround"
   "emacs-move-text"
   "emacs-crux"
   "emacs-mwim"
   "emacs-undo-fu-session"
   "emacs-vundo"
   "emacs-multiple-cursors"
   "emacs-modus-themes"
   "emacs-ef-themes"
   "emacs-spacious-padding"
   "emacs-logos"
   "emacs-olivetti"
   "emacs-rainbow-mode"
   "emacs-cursory"
   "emacs-hl-todo"
   "emacs-doom-modeline"
   "emacs-pulsar"
   "emacs-rainbow-delimiters"
   "emacs-nyan-mode"
   "emacs-lin"
   "emacs-repeat-help"
   emacs-ibuffer-project
   "emacs-gcmh"
   "emacs-wgrep"
   "emacs-project-x"
   emacs-material-icons
   "emacs-dired-hacks"
   "emacs-dired-preview"
   "emacs-ready-player"
   "mpv"
   "ffmpeg"
   "ffmpegthumbnailer"
   "emacs-emms"
   "emacs-smartparens"
   "emacs-consult"
   "emacs-consult-dir"
   "emacs-helpful"
   "emacs-elisp-demos"
   "emacs-devdocs"
   "emacs-vertico"
   "emacs-orderless"
   "emacs-marginalia"
   "emacs-embark"
   "emacs-ace-window"
   "emacs-0x0"
   "emacs-corfu"
   "emacs-nerd-icons-corfu"
   "emacs-cape"
   "emacs-tempel"
   "emacs-tempel-collection"
   "emacs-yasnippet"
   "emacs-yasnippet-snippets"
   "emacs-apheleia"
   "nixfmt"
   "emacs-consult-eglot"
   "emacs-dape"
   "emacs-eldoc-box"
   "emacs-flymake"
   "emacs-jinx"
   "hunspell"
   "hunspell-dict-en-us"
   "emacs-eros"
   "emacs-macrostep"
   "emacs-inspector"
   "emacs-org-tree-slide"
   "emacs-org-modern"
   "emacs-org-appear"
   "emacs-org-modern-indent"
   "emacs-org-contrib"
   "emacs-org-download"
   "emacs-denote"
   "emacs-denote-org"
   "emacs-denote-journal"
   "emacs-denote-sequence"
   "emacs-consult-denote"
   "emacs-org-timegrid"
   "emacs-org-ql"
   "emacs-reader"
   "emacs-nov"
   "emacs-cal-china-x"
   "emacs-elfeed"
   "emacs-elfeed-org"
   ;; elfeed-tube
   "emacs-elfeed-tube"
   "yt-dlp"
   "emacs-telega"
   "emacs-tracking"
   "emacs-magit"
   "emacs-majutsu-dolly"
   "emacs-diff-hl"
   "emacs-browse-at-remote"
   "emacs-forge"
   "emacs-git-modes"
   emacs-rime-zfc
   "emacs-guix"
   "emacs-gt"
   "sdcv"
   "emacs-tmr"
   "emacs-sops"
   "emacs-yaml-mode"
   "emacs-blue"
   "emacs-consult-ghostel"
   "emacs-ben"
   "direnv"
   "emacs-dwim-shell-command"
   "emacs-gptel"
   "emacs-gptel-agent"
   "emacs-ob-gptel"
   "emacs-gptel-prompts"
   "emacs-gptel-quick"
   emacs-gptel-preset-collection
   emacs-gptel-inline
   emacs-gptel-annotate
   "emacs-agent-shell"
   emacs-agent-shell-dashboard
   "emacs-pass"
   "password-store"
   "pass-otp"
   "notmuch"
   "emacs-notmuch"
   "isync"
   "msmtp"
   "openssl"
   "nss-certs"
   "emacs-notmuch-indicator"
   "emacs-ol-notmuch"
   "emacs-sol-mode"
   "emacs-nix-ts-mode"
   "emacs-cmake-mode"
   "emacs-rust-mode"
   "emacs-rustic"
   "emacs-fennel-mode"
   "emacs-kdl-mode"
   "emacs-just-ts-mode"
   "emacs-meson-mode"
   ;; fish plugins
   "starship"
   "zoxide"
   "fzf"
   ))

;; Everything Emacs needs to be usable: the interpreter, its elisp packages,
;; and the programs the config shells out to (mpv and ffmpeg for ready-player,
;; hunspell for jinx, sdcv for gt, isync/msmtp/notmuch for email, yt-dlp for
;; elfeed-tube, ...).  Strings go through specifications->packages, exactly as
;; they did when the list was inlined in dev.scm, so output selection is
;; unchanged.
;;
;; A procedure rather than a variable, so that no lookup runs while this module
;; is still being defined: consulting the package database loads every module on
;; the load path, the other entry files of this tree included, and those would
;; then see a half-loaded module and report %zfc-emacs-packages as unbound.
(define-public (%zfc-emacs-packages)
  (cons (specification->package "emacs-pgtk")
        (append-map (lambda (dep)
                      (if (package? dep)
                          (list dep)
                          (specifications->packages (list dep))))
                    %zfc-emacs-deps)))
