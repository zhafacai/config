(define-module (zfc home base)
  #:use-module (gnu packages)
  #:use-module (gnu packages gnupg)
  #:use-module (gnu packages fcitx5)
  #:use-module (gnu services)
  #:use-module (gnu home)
  #:use-module (gnu home services)
  #:use-module (gnu home services shells)
  #:use-module (gnu home services guix)
  #:use-module (gnu home services gnupg)
  #:use-module (gnu home services desktop)
  #:use-module (gnu home services sound)
  #:use-module (rosenthal services desktop)
  #:use-module (guix gexp)
  #:use-module (guix channels)
  #:use-module (guix transformations)
  #:use-module (zfc home packages rime-ice)
  #:use-module (zfc packages emacs-xyz)
  #:use-module (sops secrets)
  #:use-module (sops home services sops)
  #:export (home-base))

(define home-base
  (home-environment
   (packages
    (append
     (list emacs-reader)
	 (specifications->packages (list
						        ;; emacs
						        "sdcv"
						        "emacs-vterm"
						        
						        "emacs-telega"
						        
						        "emacs-eat"
						        "direnv"
						        
						        ;; "emacs-reader"
						        
						        "emacs-rime"
						        
						        "emacs-guix"
						        
						        "notmuch"
						        "emacs-notmuch"
						        "isync"
						        "msmtp"
						        "emacs-pgtk"
                                ;; dev
                                "rust"

						        ;; fonts
						        "font-google-noto-emoji"
						        "font-aporetic"
						        "font-iosevka-ss02"
						        "font-nerd-symbols"
						        "font-lxgw-wenkai"

						        "librewolf"
                                "qutebrowser"
                                "qtwayland"
						        "google-chrome-stable"
						        "noctalia-shell"
						        "virt-manager"
                                "wl-clipboard"
						        
						        ;; cli
                                "brightnessctl"
                                "fzf"
                                "just"
						        "starship"
						        "make"
						        "unzip"
						        "zoxide"
						        "btop"
						        "yt-dlp"
                                "krdc"
						        "ripgrep"
						        "fd"
						        "openssh"
						        "mpv"
						        "alacritty"
						        "fish"
						        "gcc-toolchain"
						        "xwayland-satellite"
						        "gnome-tweaks"
						        "git"
						        "mihomo"
						        "file"
						        "vim"
						        "neofetch"
						        "curl"
						        "cryptsetup"))))

   (services
    (append (list (service home-bash-service-type
			               (home-bash-configuration
			                (aliases '())
			                (environment-variables '(("EDITOR" . "emacsclient")))
			                (bashrc (list (local-file "plain/.bashrc" "bashrc")))
			                (bash-profile (list (local-file
						                         "plain/.bash_profile"
						                         "bash_profile")))))

		          (service home-pipewire-service-type)
                  (service home-gpg-agent-service-type
			               (home-gpg-agent-configuration
			                ;; (pinentry-program
                            ;;              (file-append pinentry-gnome3 "/bin/pinentry-gnome3"))
                            ;; TODO should use loopback
			                (pinentry-program
                             (file-append pinentry-emacs "/bin/pinentry-emacs"))
                            (extra-content "allow-loopback-pinentry")
			                (ssh-support? #t)))

		          (service home-files-service-type
		            `(
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
		               ,(local-file "packages/default.custom.yaml"))))
		          (service home-dbus-service-type)
		          (service home-fcitx5-service-type
		            (home-fcitx5-configuration
		              (gtk-im-module? #f)
		              (qt-im-module? #t)
		              (themes
		               (list fcitx5-material-color-theme))
		              (input-method-editors
		               (list fcitx5-rime))))
		          (simple-service 'cargo-config
		          		home-files-service-type
		          		`(( ".cargo/config.toml" ,(local-file "plain/cargo.toml"))))
		          (simple-service 'git-gpg-config
		                          home-files-service-type
		                          (list `(".gitconfig"
		                                  ,(local-file "plain/gitconfig"))))
		          (simple-service 'notmuch-prenew-config
		                          home-xdg-configuration-files-service-type
		                          (list `("notmuch/default/hooks/pre-new"
		                                  ,(local-file "plain/pre-new" #:recursive? #t))))
		          ;; XXX does not work
		          ;; (service home-sops-secrets-service-type
		          ;;          (home-sops-service-configuration
		          ;;           (secrets
		          ;;            (list
		          ;;             (sops-secret
		          ;;              (key '())
		          ;;              (output-type "binary")
		          ;;              (file (local-file "../../secrets/elfeed.org"))
		          ;;              (permissions #o400))))))
		          
		          
		          (service home-sops-secrets-service-type
		                   (home-sops-service-configuration
		                    (secrets
		                     (list
		                      (sops-secret
		                       (key '("elfeed"))
		                       (file (local-file "../../secrets/long.yaml"))
		                       (permissions #o400))))))

		          )
            %base-home-services))))
