(define-module (zfc home base)
  #:use-module (gnu packages)
  #:use-module (gnu packages fcitx5)
  #:use-module (rosenthal services desktop)
  #:use-module (gnu home services desktop)
  #:use-module (gnu home services sound)
  #:use-module (gnu packages gnupg)
  #:use-module (gnu home services gnupg)
  #:use-module (gnu home services shells)
  #:use-module (rosenthal home services desktop)
  #:use-module (gnu packages gnome-xyz)
  ;; #:use-module (nongnu packages chrome)
  #:use-module (rosenthal packages networking)
  #:use-module (gnu services)
  #:use-module (gnu home)
  #:use-module (gnu home services)
  #:use-module (guix gexp)
  #:export (home-base-packages home-base-services))

;; Package/service *components*.  Home assembly (base + dev) happens in the
;; caller: art.scm for the system-provided home, blueprint.scm's `ugh' for
;; a standalone `guix home' deploy.  This module neither builds a
;; home-environment of its own nor references `(zfc home dev)', so loading
;; it — even in the middle of a package-module scan — can never observe a
;; half-loaded dev module.
(define (home-base-packages)
  (append
   (list
    ;; google-chrome-stable
    mihomo
    )
   (specifications->packages
    (list
     ;; wm
     "noctalia-shell"
     "xwayland-satellite"
     ;; apps
     "librewolf"
     "virt-manager"
     "wl-clipboard"
     "telegram-desktop"
     "alacritty"
     "font-google-noto-emoji"
     "font-cormorant"
     "font-lxgw-markergothic"
     "font-iosevka-ss02"
     "font-iosevka-ss08"
     "font-iosevka-ss17"
     "font-iosevka-slab"
     "font-fira-code"
     "font-nerd-symbols"
     ;; "font-lxgw-wenkai"
     ;; dev
     "rust"
     "rassumfrassum"
     "fnlfmt"
     ;; cli
     "brightnessctl"
     "bat"
     "ddcutil"
     "github-cli"
     "tree-sitter-cli"
     "bluez"
     "openssh"
     "just"
     "make"
     "unzip"
     "btop"
     "sops"
     "yt-dlp"
     "gcc-toolchain"
     "git"
     "jujutsu"
     "file"
     "neovim"
     "neofetch"
     "curl"
     "7zip"
     "imagemagick"
     "eza"
     "cryptsetup"
     ;; shell history (atuin takes over C-r in fish; fzf.fish keeps the rest)
     "atuin"
     ;; git diff pager (see gitconfig section)
     "git-delta"
     "gnupg"
     ))))

(define home-base-services
  (append
   (list
    (service home-pipewire-service-type)
    (service home-files-service-type
             `(
               (".local/share/fcitx5/rime/default.custom.yaml"
                ,(local-file "../../../files/plain/default.custom.yaml"))
               ))
    (service home-dbus-service-type)
    (service home-graphical-session-service-type
             (home-graphical-session-configuration
              (wayland? #t)
              (x11? #t)))
    (service home-fcitx5-service-type
             (home-fcitx5-configuration
              (wayland-frontend? #t)
              (themes
               (list fcitx5-material-color-theme))
              (input-method-editors
               (list fcitx5-rime))))
    (service home-gpg-agent-service-type
             (home-gpg-agent-configuration
              (pinentry-program (file-append pinentry-qt "/bin/pinentry-qt"))
              (default-cache-ttl 1800)
              (extra-content "allow-loopback-pinentry")
              (ssh-support? #t)))
    (service home-bash-service-type
    		 (home-bash-configuration
    		   (aliases '(("em" . "emacsclient")
    					  ("e" . "nvim")))
    		   (environment-variables '())
    		   (bashrc (list (local-file "../../../files/plain/.bashrc" "bashrc")))
    		   (bash-profile (list (local-file
    								"../../../files/plain/.bash_profile"
    								"bash_profile")))))
    (service home-theme-service-type
             (home-theme-configuration
              (packages (list qogir-icon-theme))
              (icon-theme "Qogir")
              (cursor-theme "Qogir")))
    )
   %base-home-services))
