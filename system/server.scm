;; Testing server configuration

;; Import guix module.
(use-modules (gnu))
(use-service-modules networking ssh)

(operating-system
 ;; Base system config.
 (locale "en_US.utf8")
 (timezone "Asia/Shanghai")
 (keyboard-layout (keyboard-layout "us"))
 (host-name "PlayGuix")
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
	  "tmux"
	  "ranger"
	  "neofetch"
	  "btrfs-progs"
	  "git"
	  "htop"
	  ;; Languags
	  "go"	  
	  "ghc"	  
	  ;; Emacs and Packages
	  "emacs-no-x"))
   %base-packages))

 ;; Base services
 (services
  (append
   (list (service openssh-service-type)
         (service dhcp-client-service-type))
   %base-services))

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
