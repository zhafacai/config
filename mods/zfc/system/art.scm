;; -*- mode: scheme; -*-
(define-module (zfc system art)
  #:use-module (gnu)
  #:use-module (gnu services virtualization)
  #:use-module (gnu services nix)
  #:use-module (gnu services shepherd)
  #:use-module (gnu services networking)
  #:use-module (saayix packages terminals)
  #:use-module (gnu system nss)
  #:use-module (gnu services sddm)
  #:use-module (gnu services desktop)
  #:use-module (gnu services xorg)
  #:use-module (gnu services guix)
  #:use-module (gnu home)
  #:use-module (gnu home services)
  #:use-module (nongnu packages linux)
  #:use-module (nongnu system linux-initrd)
  #:use-module (rosenthal utils file)
  #:use-module (zfc home base)
  #:use-module (zfc home dev))

(define %network-manager-ipv6-privacy
  `("ip6-privacy.conf"
	,(ini-file "ip6-privacy.conf"
	   #~'(("connection"
			("ipv6.ip6-privacy" . 2))))))

(define %network-manager-random-mac-address
  `("random-mac-address.conf"
    ,(ini-file "random-mac-address.conf"
       #~'(("connection-mac-randomization"
            ("ethernet.cloned-mac-address" . "stable")
            ("wifi.cloned-mac-address" . "stable"))))))

(operating-system
 (kernel linux)
 (initrd microcode-initrd)
 (firmware (list linux-firmware))
 (host-name "art")
 (timezone "Asia/Shanghai")
 (locale "en_US.utf8")

 (keyboard-layout (keyboard-layout "us"
                                   #:options '("ctrl:nocaps")))

 (sudoers-file
  (plain-file "sudoers"
              (string-append (plain-file-content %sudoers-specification)
                             (format #f "~a ALL = NOPASSWD: ALL~%" "zfc"))))

 (bootloader (bootloader-configuration
              (bootloader grub-efi-bootloader)
              (targets '("/boot/efi"))
              (keyboard-layout keyboard-layout)))

 (mapped-devices
  (list (mapped-device
         (source (uuid "e4498dc2-0360-4844-9328-9da4ea9d32b9"))
         (target "cryptroot")
         (type luks-device-mapping))))

 (file-systems (append
                (list (file-system
                       (device (file-system-label "root"))
                       (mount-point "/")
                       (type "ext4")
                       (dependencies mapped-devices))
                      ;; TODO remove this
                      (file-system
                       (device (uuid "9CBE79B6BE798992" 'ntfs))
                       (mount-point "/home/zfc/Windows/")
                       (type "ntfs"))
                      (file-system
                       (device (uuid "30E7-C51B" 'fat))
                       (mount-point "/boot/efi")
                       (type "vfat")))
                %base-file-systems))

 (swap-devices (list (swap-space
                      (target "/swapfile"))))

 (users (cons (user-account
               (name "zfc")
               (comment "zhafacai")
               (group "users")
               (password "$6$RHK3ZQYo7KixPw/f$Wz1cc8nIU.AlQ7UuFQ/mPYQGa4.jt0vzZ8UeHlpS0znTEM7qg3ael8RJbCczYMp.I8YqIP0x7Nrg9A6opT1TU0")
               (supplementary-groups '("wheel" "netdev"
                                       "libvirt"
                                       "audio" "video")))
              %base-user-accounts))


 (packages (append (list
                    ghostty
                    ;; yazi
                    )
                   (specifications->packages
                    (list
                     "gcr@3"
                     "neovim"
                     "niri"
                     "xdg-desktop-portal-gnome"
                     "xdg-desktop-portal-gtk"
                     "gnome-keyring"
                     "libsecret"
  					 "gvfs"
                     ))
                   %base-packages))

 (services (append (list
                    (service bluetooth-service-type
                             (bluetooth-configuration (auto-enable? #t)))
                    (service libvirt-service-type
                             (libvirt-configuration))
                    (service virtlog-service-type
                             (virtlog-configuration))
                    (service nix-service-type
                      (nix-configuration
                    	(extra-config
                    	 '("experimental-features = nix-command flakes\n"
                    	   "trusted-users = zfc root\n"
                    	   "substituters =  https://mirrors.ustc.edu.cn/nix-channels/store/ https://cache.nixos.org/\n"))))
                    (simple-service 'mihomo
                    				shepherd-root-service-type
                    				(list
                    				 (shepherd-service
                    				  (provision '(mihomo))
                    				  (requirement '(networking))
                    				  (auto-start? #t)
                    				  (start #~(make-forkexec-constructor
                    							(list #$(file-append (specification->package "mihomo") "/bin/mihomo")
                    								  "-d" "/root/.config/mihomo"
                    								  "-f" "/root/.config/mihomo/config.yaml")
                    							#:log-file "/var/log/mihomo.log"))
                    				  (stop #~(make-kill-destructor)))))
  		            (service sddm-service-type)
                    (service guix-home-service-type
  							 `(("zfc" ,(home-environment
  										(packages (append home-base-packages
  														  %zfc-dev-packages))
  										(services (append home-base-services
  														  %zfc-dev-services))))))
                    polkit-wheel-service)
                   (modify-services %desktop-services
                                    (delete gdm-service-type)
  									(network-manager-service-type
  									 config => (network-manager-configuration
  												 (inherit config)
  												 (extra-configuration-files
  												  (list %network-manager-ipv6-privacy
  														%network-manager-random-mac-address))))
  									(guix-service-type
  									 config => (guix-configuration
  									            (inherit config)
  									            (authorized-keys
  									             (append (list (local-file "../../../files/system/signing-key.pub")
  									                           (local-file "../../../files/system/guix-moe.pub"))
  									                     %default-authorized-guix-keys))
  									            (substitute-urls '("https://mirror.sjtu.edu.cn/guix/"
  																   "https://cache-cdn.guix.moe"
  									                               "https://substitutes.nonguix.org"
  									                               "https://ci.guix.gnu.org"))))
  									)))

 ;; Allow resolution of '.local' host names with mDNS.
 (name-service-switch %mdns-host-lookup-nss))
