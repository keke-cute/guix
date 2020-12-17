;; This is my guix configuration

;; Import guix module.
(use-modules (gnu) (srfi srfi-1) (gnu services xorg))
(use-service-modules desktop networking ssh)

;; Import nonfree linux module.
(use-modules (nongnu packages linux)
             (nongnu system linux-initrd))

(operating-system
 ;; Base system config.
 (kernel linux)
 (initrd microcode-initrd)
 (firmware (cons* iwlwifi-firmware
                 %base-firmware)) 
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
	  "tmux"
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
         %base-file-systems))
 (swap-devices '("/var/swapfile")))
