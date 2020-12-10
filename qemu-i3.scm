;; This is an operating system configuration generated
;; by the graphical installer.

(use-modules (gnu))
(use-service-modules desktop networking ssh xorg)

(operating-system
  (locale "en_US.utf8")
  (timezone "Asia/Shanghai")
  (keyboard-layout (keyboard-layout "us"))
  (host-name "guix")
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
      (list (specification->package "i3-wm")
            (specification->package "i3status")
            (specification->package "dmenu")
            (specification->package "st")
            (specification->package "nss-certs"))
      %base-packages))
  (services
    (append
      (list (service
              openssh-service-type
              (openssh-configuration
                (password-authentication? #f)))
            (set-xorg-configuration
              (xorg-configuration
                (keyboard-layout keyboard-layout))))
      %desktop-services))
  (bootloader
    (bootloader-configuration
      (bootloader grub-efi-bootloader)
      (target "/boot/efi")
      (keyboard-layout keyboard-layout)))
  (swap-devices
    (list (uuid "0c503864-869a-42a1-bfab-69e0a5a742e7")))
  (file-systems
    (cons* (file-system
             (mount-point "/boot/efi")
             (device (uuid "D1AB-AC56" 'fat32))
             (type "vfat"))
           (file-system
             (mount-point "/")
             (device
               (uuid "984421b9-11f5-4227-8472-2f57382fa1cc"
                     'ext4))
             (type "ext4"))
           %base-file-systems)))
