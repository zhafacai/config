(define-module (zfc home base)
  #:use-module (gnu packages)
  #:use-module (gnu packages fcitx5)
  #:use-module (rosenthal services desktop)
  #:use-module (gnu home services desktop)
  #:use-module (gnu home services sound)
  #:use-module (gnu home services shells)
  #:use-module (rosenthal home services desktop)
  #:use-module (gnu packages gnome-xyz)
  ;; #:use-module (nongnu packages chrome)
  #:use-module (rosenthal packages networking)
  #:use-module (gnu services)
  #:use-module (gnu home)
  #:use-module (gnu home services)
  #:use-module (guix gexp)
  #:use-module (zfc home packages rime-ice)
  #:use-module (zfc home dev)
  #:export (home-base))

(define home-base
  (home-environment
   (packages
    (append
     (list
	  ;; google-chrome-stable
	  mihomo
	  )
     (specifications->packages
      (list
       ;; wm
       "noctalia"
       "xwayland-satellite"
       ;; apps
       "librewolf"
       "qutebrowser"
       "qtwayland"
       "virt-manager"
       "wl-clipboard"
       "telegram-desktop"
       "krdc"
       "alacritty"
       "font-google-noto-emoji"
       "font-cormorant"
       "font-lxgw-markergothic"
       "font-iosevka-ss02"
       "font-iosevka-ss08"
       "font-iosevka-ss17"
       "font-iosevka-slab"
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
       "delta"
       ))
     ;; NOTE: %zfc-dev-packages is a function in (zfc home dev) so that its
     ;; `specifications->packages' call stays out of dev's module load.  That
     ;; way the package-module scan that `-L' triggers never finds a
     ;; half-loaded dev module (see the NOTE in dev.scm).
     (%zfc-dev-packages)))

   (services
    (append (list 
             (service home-pipewire-service-type)
             (service home-files-service-type
                      `(
                        ;; NOTE on rime data: these entries symlink read-only store paths into the
                        ;; rime user data dir.  rime reads them fine and keeps its writable state
                        ;; (userdb, build/) in the user dir itself.  If you ever see rime failing to
                        ;; write user dictionaries, convert the *directory* links below (cn_dicts /
                        ;; en_dicts / opencc / lua) to file-level links or a writable copy.
                        ;; 1. Link the heavy data directories
                        (".local/share/fcitx5/rime/en_dicts" ,(file-append rime-ice "/share/rime-data/en_dicts"))
                        (".local/share/fcitx5/rime/cn_dicts" ,(file-append rime-ice "/share/rime-data/cn_dicts"))
                        (".local/share/fcitx5/rime/opencc" ,(file-append rime-ice "/share/rime-data/opencc"))
                        (".local/share/fcitx5/rime/lua"    ,(file-append rime-ice "/share/rime-data/lua"))
                        
                        ;; 2. Link the essential schema files for Xiaohe
                        (".local/share/fcitx5/rime/double_pinyin_flypy.schema.yaml" 
                         ,(file-append rime-ice "/share/rime-data/double_pinyin_flypy.schema.yaml"))
                        (".local/share/fcitx5/rime/rime_ice.schema.yaml" 
                         ,(file-append rime-ice "/share/rime-data/rime_ice.schema.yaml"))
                        (".local/share/fcitx5/rime/default.yaml" 
                         ,(file-append rime-ice "/share/rime-data/default.yaml"))
                        (".local/share/fcitx5/rime/rime_ice.dict.yaml" 
                         ,(file-append rime-ice "/share/rime-data/rime_ice.dict.yaml"))
                        (".local/share/fcitx5/rime/symbols_v.yaml" 
                         ,(file-append rime-ice "/share/rime-data/symbols_v.yaml"))
                        (".local/share/fcitx5/rime/symbols_caps_v.yaml" 
                         ,(file-append rime-ice "/share/rime-data/symbols_caps_v.yaml"))
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
            %zfc-dev-services
            %base-home-services))))

home-base
