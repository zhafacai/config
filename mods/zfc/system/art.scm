;; -*- mode: scheme; -*-
(define-module (zfc system art)
  #:use-module (gnu)
  #:use-module (gnu system nss)
  #:use-module (gnu packages wm)
  #:use-module (gnu packages shells)
  #:use-module (gnu packages gnome)
  #:use-module (gnu packages vim)
  #:use-module (gnu services desktop)
  #:use-module (gnu services xorg)
  #:use-module (gnu services nix)
  #:use-module (gnu services virtualization)
  #:use-module (gnu services guix)
  #:use-module (gnu home)
  #:use-module (gnu home services)
  #:use-module (guix packages)
  #:use-module (guix channels)
  #:use-module (nongnu packages linux)
  #:use-module (nongnu system linux-initrd)
  ;; #:use-module (guixcn services networking)
  #:use-module (zfc packages networking)
  #:use-module (rosenthal services child-error)
  ;; #:use-module (sops secrets)
  ;; #:use-module (sops services sops)
  #:use-module ((ice-9 popen) #:select (open-input-pipe close-pipe))
  #:use-module ((rnrs io ports) #:select (get-string-all))
  ;; #:use-module ((sops secrets) #:select (sanitize-sops-key))
  #:use-module (zfc home base))

(define %subs-services
  ;; my service to use substituters
  (modify-services %desktop-services
                   (guix-service-type
                    config => (guix-configuration
                               (inherit config)
                               (authorized-keys
                                (append (list (local-file "./signing-key.pub")
                                              (plain-file "guix-moe.pub"
                                                          "(public-key (ecc (curve Ed25519) (q #552F670D5005D7EB6ACF05284A1066E52156B51D75DE3EBD3030CD046675D543#)))"))
                                        %default-authorized-guix-keys))
                               (substitute-urls '("https://mirror.sjtu.edu.cn/guix/"
                                                  "https://cache-cdn.guix.moe"
                                                  "https://substitutes.nonguix.org"
                                                  "https://ci.guix.gnu.org"))))))



(operating-system
 (kernel linux-6.6)
 (initrd microcode-initrd)
 (firmware (list linux-firmware))
 (host-name "art")
 (timezone "Asia/Shanghai")
 (locale "en_US.utf8")

 ;; Choose US English keyboard layout.  The "altgr-intl"
 ;; variant provides dead keys for accented characters.
 (keyboard-layout (keyboard-layout "us"
                                   #:options '("ctrl:nocaps")))

 ;; Use the UEFI variant of GRUB with the EFI System
 ;; Partition mounted on /boot/efi.
 (bootloader (bootloader-configuration
              (bootloader grub-efi-bootloader)
              (targets '("/boot/efi"))
	          (keyboard-layout keyboard-layout)))

 ;; Specify a mapped device for the encrypted root partition.
 ;; The UUID is that returned by 'cryptsetup luksUUID'.
 (mapped-devices
  (list (mapped-device
         (source (uuid "7a3e1a89-474c-4efb-8826-2470162e7a66"))
         (target "root")
	     (type luks-device-mapping))))

 (file-systems (append
                (list (file-system
                       (device (file-system-label "root"))
                       (mount-point "/")
                       (type "ext4")
                       (dependencies mapped-devices))
                      (file-system
                       (device (uuid "558B-E023" 'fat))
                       (mount-point "/boot/efi")
                       (type "vfat")))
                %base-file-systems))

 ;; Specify a swap file for the system, which resides on the
 ;; root file system.
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


 ;; This is where we specify system-wide packages.
 (packages (append (list
		            neovim
		            niri
		            xdg-desktop-portal-gnome
                    gvfs)
                   %base-packages))

 (services (append (list (service gnome-desktop-service-type)
			             (service bluetooth-service-type)
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
			             (service guix-home-service-type
				                  `(("zfc" ,home-base)))
			             polkit-wheel-service)
		           %subs-services))

 ;; Allow resolution of '.local' host names with mDNS.
 (name-service-switch %mdns-host-lookup-nss))
