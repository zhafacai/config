(define-module (zfc home base)
  #:use-module (gnu packages)
  #:use-module (gnu packages gnupg)
  #:use-module (gnu packages fcitx5)
  #:use-module (gnu packages shells)
  #:use-module (zfc config common)
  #:use-module (gnu home services shepherd)
  #:use-module (gnu packages mail)
  #:use-module (gnu packages bash)
  #:use-module (rosenthal services desktop)
  #:use-module (gnu packages gnome-xyz)
  #:use-module (sops secrets)
  #:use-module (sops home services sops)
  ;; #:use-module (nongnu packages chrome)
  #:use-module (bluebox packages blue)
  #:use-module (rosenthal packages networking)
  #:use-module (gnu services)
  #:use-module (gnu home)
  #:use-module (gnu home services)
  #:use-module (gnu home services shells)
  #:use-module (gnu home services guix)
  #:use-module (gnu home services gnupg)
  #:use-module (gnu home services desktop)
  #:use-module (gnu home services sound)
  #:use-module (rosenthal home services desktop)
  #:use-module (rosenthal packages wm)
  #:use-module (guix gexp)
  #:use-module (guix channels)
  #:use-module (guix transformations)
  #:use-module (zfc home packages rime-ice)
  #:use-module (zfc home dev)
  #:use-module (zfc packages emacs-xyz)
  #:use-module (zfc packages fonts)
  #:export (home-base))

(define home-base
  (home-environment
   (packages
    (append
     (list
	  ;; google-chrome-stable
	  mihomo
	  )
     (specifications->packages (append
                                (list
                                 ;; wm
                                 "noctalia"
                                 ;; dev
                                 "rust"
                                 "rassumfrassum"

						         ;; fonts
						         "font-google-noto-emoji"
						         "font-cormorant"
								 "font-lxgw-markergothic"
						         "font-iosevka-ss02"
								 "font-iosevka-ss08"
								 "font-iosevka-ss17"
								 "font-iosevka-slab"
								 "font-nerd-symbols"
								 ;; "font-lxgw-wenkai"

								 "librewolf"
								 "qutebrowser"
								 "qtwayland"
								 "virt-manager"
								 "wl-clipboard"

								 ;; cli
								 "brightnessctl"
								 "bat"
								 "telegram-desktop"
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
								 "krdc"
								 "alacritty"
								 "gcc-toolchain"
								 "xwayland-satellite"
								 "git"
								 "file"
								 "neovim"
								 "neofetch"
								 "curl"
								 ;; fennel
								 "fnlfmt"


								 
								 "7zip"
								 "imagemagick"
								 "eza"

								 "cryptsetup")
                                %zfc-dev-packages))))

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
                         ,(local-file "packages/default.custom.yaml"))
                        
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
             		   (bashrc (list (local-file "plain/.bashrc" "bashrc")))
             		   (bash-profile (list (local-file
             								"plain/.bash_profile"
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
