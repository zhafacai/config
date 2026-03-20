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
  #:export (home-base))

(define transform1
  (options->transformation '((with-branch . "emacs-reader=master"))))

(define home-base
  (home-environment
   ;; Below is the list of packages that will show up in your
   ;; Home profile, under ~/.guix-home/profile.
   (packages (append (list (transform1 (specification->package "emacs-reader")))
		     (specifications->packages (list
						;; emacs
						"sdcv"
						"emacs-vterm"
						
						"emacs-telega"
						
						"emacs-eat"
						"direnv"
						"emacs-rime"
						
						"emacs-guix"
						
						"notmuch"
						"emacs-notmuch"
						"isync"
						"emacs-pgtk"
						
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
						
						;; cli
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
						"gcc-toolchain@14"
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
			    (pinentry-program
                             (file-append pinentry-emacs "/bin/pinentry-emacs"))
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
		  (simple-service 'variant-packages-service
		      home-channels-service-type
		    (list
		     (channel
		       (inherit (car %default-channels))
		       (url "https://mirror.sjtu.edu.cn/git/guix.git"))
		     (channel
		       (name 'nonguix)
		       (url "https://gitlab.com/nonguix/nonguix")
		       (introduction
		        (make-channel-introduction
		         "897c1a470da759236cc11798f4e0a5f7d4d59fbc"
		         (openpgp-fingerprint
		          "2A39 3FFF 68F4 EF7A 3D29  12AF 6F51 20A0 22FB B2D5"))))
		     (channel
		       (name 'rosenthal)
		       (url "https://codeberg.org/hako/rosenthal.git")
		       (branch "trunk")
		       (introduction
		        (make-channel-introduction
		         "7677db76330121a901604dfbad19077893865f35"
		         (openpgp-fingerprint
		          "13E7 6CD6 E649 C28C 3385  4DF5 5E5A A665 6149 17F7"))))
		     (channel
		       (name 'divya-lambda)
		       (url "https://codeberg.org/divyaranjan/divya-lambda.git")
		       (branch "master")
		       (introduction
		        (make-channel-introduction
		         "fe2010125fcbe003de42436b1a73ab53cc5e8288"
		         (openpgp-fingerprint
		          "F0B3 1A69 8006 8FB8 096A  2F12 B245 10C6 108C 8D4A"))))))
		  (simple-service 'cargo-config
		  		home-files-service-type
		  		`(( ".cargo/config.toml" ,(local-file "plain/cargo.toml"))))

		  )
            %base-home-services))))
