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
 (mapped-devices
  (list (mapped-device
         (source
          (uuid "46fcb586-6758-441c-84ff-b7a43777bd81"))
         (target "root")
         (type luks-device-mapping))))
 (file-systems
  (cons* (file-system
          (mount-point "/")
          (device "/dev/mapper/root")
          (type "btrfs")
	  (options "compress-force=zstd")
          (dependencies mapped-devices))
         (file-system
          (mount-point "/boot/efi")
          (device (uuid "0826-DC04" 'fat32))
          (type "vfat"))
         %base-file-systems)))
