;; This is an operating system configuration generated
;; by the graphical installer.

(use-modules (gnu) (gnu packages emacs) (gnu packages emacs-xyz) (guix packages) (guix utils))
(use-service-modules desktop networking ssh xorg)
;; Import nonfree linux module.
(use-modules (nongnu packages linux)
             (nongnu system linux-initrd))

(operating-system
  (kernel linux)
  (initrd microcode-initrd)
  (firmware (list linux-firmware))
  (locale "en_US.utf8")
  (timezone "Asia/Shanghai")
  (keyboard-layout (keyboard-layout "us"))
  (host-name "KeaiGuix")
  (users (cons* (user-account
                  (name "keke")
                  (comment "Shike Liu")
                  (group "users")
                  (home-directory "/home/keke")
                  (supplementary-groups
                    '("wheel" "netdev" "audio" "video")))
                %base-user-accounts))
  (packages
    (append
	(cons*
	 (package
	  (inherit emacs-exwm)
	  (name "emacs-exwm-z")
	   (arguments 
	    (substitute-keyword-arguments
	      (package-arguments emacs-exwm)
	       ((#:emacs emacs) `,emacs-xwidgets))))
	emacs-xwidgets
	(map specification->package
	     `("nss-certs"
	       "btrfs-progs"
	       "glib-networking"
	       "git")))
;;	       "emacs-xwidgets")))
;;	       "emacs-desktop-environment")))
;;      (list (specification->package "emacs-xwidgets")
;;            (specification->package "emacs-exwm")
;;        (list (specification->package "btrfs-progs")	
;;            (specification->package
;;              "emacs-desktop-environment")
;;            (specification->package "nss-certs"))
      %base-packages))
  (services
    (append
      (list (service openssh-service-type)
            (set-xorg-configuration
              (xorg-configuration
                (keyboard-layout keyboard-layout))))
      %desktop-services))
  (bootloader
    (bootloader-configuration
      (bootloader grub-efi-bootloader)
      (target "/boot/efi")
      (keyboard-layout keyboard-layout)))
  (mapped-devices
    (list (mapped-device
            (source
              (uuid "a7f191ac-75fe-474b-92d9-b0b232bb290f"))
            (target "root")
            (type luks-device-mapping))))
  (file-systems
    (cons* (file-system
             (mount-point "/")
             (device "/dev/mapper/root")
             (type "btrfs")
	     (options "compress-force=zstd:9")
             (dependencies mapped-devices))
           (file-system
             (mount-point "/boot/efi")
             (device (uuid "5C4A-6847" 'fat32))
             (type "vfat"))
           %base-file-systems))
   (swap-devices '("/var/swapfile")))
