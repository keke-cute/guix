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
	`("nss-certs"
	  "ranger"
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
          (device (uuid "CA6E-3C2A" 'fat32))
          (type "vfat"))
         (file-system
          (mount-point "/")
          (device
           (uuid "8cac0fed-553d-483f-b39f-a8168d28effe"
                 'btrfs))
	  (options "compress-force=zstd")
          (type "btrfs"))
         %base-file-systems)))
