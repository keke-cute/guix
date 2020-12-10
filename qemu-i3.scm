;; this is my guix configuration in qemu

;; Import guix module.
(use-modules (gnu))
(use-service-modules desktop networking ssh sddm xorg)

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
   (service sddm-service-type)
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
          (device (uuid "D1AB-AC56" 'fat32))
          (type "vfat"))
         (file-system
          (mount-point "/")
          (device
           (uuid "984421b9-11f5-4227-8472-2f57382fa1cc"
                 'btrfs))
	  (options "compress-force=zstd")
          (type "btrfs"))
         %base-file-systems)))
