(define-module (my-dwm)
  #:use-module (gnu packages)
  #:use-module (gnu packages suckless)
  #:use-module (guix git-download)
  #:use-module (guix packages)
  #:use-module (guix utils))

(define-public my-dwm
  (package
   (inherit dwm)
   (name "my-dwm")
   (version "fbfc3da125f93034779b22d35befbd09be5b1d6d")
   (source
    (origin
     (method git-fetch)
     (uri (git-reference
           (url "https://github.com/keke-cute/dwm.git")
           (commit version)))
     (file-name (git-file-name name version))
     (sha256
      (base32
       "0i72jbs1k49r4f4yx8k9144fiyc4213f1bw79cxjaffjsm83vkvd"))))))
