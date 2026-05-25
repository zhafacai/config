(define-module (zfc home base)
  #:use-module (gnu packages)
  #:use-module (gnu packages gnupg)
  #:use-module (gnu packages fcitx5)
  #:use-module (gnu packages shells)
  #:use-module (gnu home services shepherd)
  #:use-module (gnu packages mail)
  #:use-module (sops secrets)
  #:use-module (sops home services sops)
  #:use-module (nongnu packages chrome)
  #:use-module (bluebox packages blue)
  #:use-module (rosenthal packages wm)
  #:use-module (rosenthal packages networking)
  #:use-module (gnu services)
  #:use-module (gnu home)
  #:use-module (gnu home services)
  #:use-module (gnu home services shells)
  #:use-module (gnu home services guix)
  #:use-module (gnu home services gnupg)
  #:use-module (gnu home services desktop)
  #:use-module (gnu home services sound)
  #:use-module (rosenthal services desktop)
  #:use-module (rosenthal home services desktop)
  #:use-module (guix gexp)
  #:use-module (guix channels)
  #:use-module (guix transformations)
  #:use-module (zfc home packages rime-ice)
  #:use-module (zfc packages emacs-xyz)
  #:export (home-base))

(define home-base
  (home-environment
   (packages
    (append
     (list
	  
	  emacs-reader
	  
	  google-chrome-stable
	  blue
	  noctalia-shell
	  mihomo
	  )
     (specifications->packages (list
                                ;; emacs
                                
                                "emacs-telega"
                                
                                "emacs-rime"
                                
                                "emacs-guix"
                                
                                "sdcv"
                                "direnv"
                                "notmuch"
                                "emacs-notmuch"
                                "isync"
                                "msmtp"
                                "emacs-next-pgtk"
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
                                "fzf"
                                "just"
						        "starship"
						        "make"
						        "unzip"
						        "zoxide"
						        "btop"
								"sops"
						        "yt-dlp"
                                "krdc"
						        "ripgrep"
						        "fd"
						        "mpv"
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


								;; dirvish
								"vips"
								"poppler"
								"ffmpegthumbnailer"
								"epub-thumbnailer"
								"mediainfo"
								"7zip"
								"imagemagick"
								"eza"

						        "cryptsetup"))))

   (services
    (append (list 
             (service home-pipewire-service-type)
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
                         ,(local-file "packages/default.custom.yaml"))
                        
                        ("Downloads/.dir-locals.el" ,(local-file "plain/Downloads.el"))
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
                                (pinentry-program (file-append pinentry-gnome3 "/bin/pinentry-gnome3"))
                                (default-cache-ttl 1800)
                                (extra-content "allow-loopback-pinentry")
                                (ssh-support? #t)))
                      (simple-service 'base-env-vars-service
                                      home-environment-variables-service-type
                                      `(("EDITOR" . "emacsclient")))
                      (service home-bash-service-type
                      		 (home-bash-configuration
                      		   (aliases '(("em" . "emacsclient")
                      					  ("e" . "nvim")))
                      		   (environment-variables '())
                      		   (bashrc (list (local-file "plain/.bashrc" "bashrc")))
                      		   (bash-profile (list (local-file
                      								"plain/.bash_profile"
                      								"bash_profile")))))
                      (service home-fish-service-type
                               (home-fish-configuration
                                 (config
                                  (list (plain-file "fish_greeting.fish" "set -g fish_greeting")
                                        (plain-file "plugins.fish" (string-append "starship init fish | source\n"
                                                                                  "zoxide init fish | source\n"
                      															"fish_config theme choose catppuccin-mocha\n"
                                                                                  "direnv hook fish | source"))))))
                      
                      
                      (simple-service 'fish-fisher-service
                                      home-shepherd-service-type
                                      (list
                                       (shepherd-service
                                        (provision '(fish-fisher))
                                        (one-shot? #t)
                                        (start
                                         #~(lambda ()
                                             (use-modules (guix build utils)
                                                          (zfc config common))
                                             (let* ((source (canonicalize-path (config-files-path "fish/fish_plugins")))
                                                    (target (string-append (getenv "XDG_CONFIG_HOME") "/fish/fish_plugins"))
                                                    (fish-bin #$(file-append fish "/bin/fish")))
                                               
                                               (format #t "Directly symlinking fish_plugins (~a) to ~a~%" source target)
                                               (when (false-if-exception (lstat target))
                                                 (delete-file target))
                                               (symlink source target)
                                               
                                               (unless (file-exists? (string-append (getenv "XDG_CONFIG_HOME") "/fish/functions/fisher.fish"))
                                                 (format #t "Installing fisher~%")
                                                 (system (string-append fish-bin " -c \"curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | "
                                                                        "source && fisher install jorgebucaran/fisher\"")))
                                               
                                               (format #t "Updating fisher plugins~%")
                                               (system (string-append fish-bin " -c \"fisher update\""))
                                               #t)))
                                        (documentation "Initialize and update Fish plugins via fisher."))))
                      
                      (simple-service 'cargo-config
                      	home-files-service-type
                        `(( ".cargo/config.toml" ,(local-file "plain/cargo.toml"))))
                      (simple-service 'git-gpg-config
                          home-files-service-type
                        (list `(".gitconfig"
                                ,(local-file "plain/gitconfig"))))
                      (simple-service 'mbsync-gmail-timer-service
                                      home-shepherd-timer-service-type
                                      (list
                                       (shepherd-timer
                                        '(mbsync-gmail)
                                        "0 12 * * *"
                                        #~(#$(file-append isync "/bin/mbsync") "gmail")
                                        #:documentation "Synchronize Gmail via mbsync daily at noon.")))
                      (simple-service 'notmuch-config-service
                                      home-files-service-type
                                      (list
                                       `(".config/notmuch/default/config"
                                         ,(mixed-text-file "notmuch-config"
                                                           "[user]\n"
                                                           "primary_email=zhafacai@gmail.com\n"))))
                      
                      ;; cannot use getenv HOME in home-files-service-type
                      (simple-service 'notmuch-env-service
                                      home-environment-variables-service-type
                                      `(("NOTMUCH_DATABASE" . ,(string-append (getenv "HOME") "/Documents/Mail"))))
                      
                      ;; (service home-sops-secrets-service-type
                      ;;          (home-sops-service-configuration
                      ;;           (secrets
                      ;;            (list
                      ;;             (sops-secret
                      ;;              (key '("data"))
                      ;;              (output-type "binary")
                      ;;              (file (local-file "../../../secrets/elfeed.org"))
                      ;;              (permissions #o400))))))
                      
                      
                      (service home-sops-secrets-service-type
                        (home-sops-service-configuration
                          (secrets
                           (list
                            (sops-secret
                              (key '("elfeed"))
                              (file (local-file "../../../secrets/text.yaml"))
                              (permissions #o400))))))
                      )
             %base-home-services))))

  home-base
