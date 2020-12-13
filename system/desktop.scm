;; This is my guix configuration

;; Import guix module.
(use-modules (gnu) (srfi srfi-1) (gnu services xorg))
(use-service-modules desktop networking ssh)

(operating-system
 ;; Base system config.
 (locale "en_US.utf8")
 (timezone "Asia/Shanghai")
 (keyboard-layout (keyboard-layout "us"))
 (host-name "playground")
 (users (cons* (user-account
                (name "keke")
                (comment "Shike Liu")
                (group "users")
                (home-directory "/home/keke")
                (supplementary-groups
                 '("wheel" "netdev" "audio" "video")))
               %base-user-accounts))
 ;; System app list
 (packages
  (append
   (map specification->package
	`(;; Basic Tools
	  "nss-certs"
	  "ranger"
	  "neofetch"
	  "btrfs-progs"
	  "git"
	  "htop"
	  "flameshot"
	  "feh"
	  "picom"
	  ;; Borrwser
	  "icecat"
	  ;; Languags
	  "go"	  
	  "ghc"	  
	  ;; Emacs and Packages
	  "emacs-rime"
	  "emacs-telega"
	  "emacs-vterm"
	  "emacs-exwm"
	  "emacs"))
   %base-packages))

 ;; Base services
  (services
  (cons*
   (service openssh-service-type)
   (service slim-service-type)
   (modify-services
    ;; Remove GDM.
    (remove (lambda (service)
              (eq? (service-kind service) gdm-service-type))
            %desktop-services))))

 ;; Bootloader
 (bootloader
  (bootloader-configuration
   (bootloader grub-efi-bootloader)
   (target "/boot/efi")))

 ;;FileSystem
 (file-systems
  (cons* (file-system
          (mount-point "/boot/efi")
          (device (uuid "E7E0-A829" 'fat32))
          (type "vfat"))
         (file-system
          (mount-point "/")
          (device
           (uuid "8dac5ac5-9552-446e-833c-7ff64f69f5b5"
                 'btrfs))
	  (options "compress-force=zstd")
          (type "btrfs"))
         %base-file-systems)))
