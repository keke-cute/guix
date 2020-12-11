;; this is my guix configuration in qemu

;; Import guix module.
(use-modules (gnu) (rnrs lists))
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
	`("nss-certs"
	  "ranger"
	  "sway"
	  "neofetch"
	  "rofi"
	  "btrfs-progs"
	  "git"
	  "emacs"
	  "alacritty"))
   %base-packages))
 
 ;; Base services
  (services
  (cons*
   (service openssh-service-type)
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
          (device (uuid "F710-6481" 'fat32))
          (type "vfat"))
         (file-system
          (mount-point "/")
          (device
           (uuid "45e10aab-3534-4b5c-8291-26e9decd5a79"
                 'btrfs))
	  (options "compress-force=zstd")
          (type "btrfs"))
         %base-file-systems)))
