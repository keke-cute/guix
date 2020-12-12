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
   (version "1.0.0")
   (source
    (origin
     (method git-fetch)
     (uri (git-reference
           (url "https://github.com/keke-cute/dwm.git")
           (commit version)))
     (file-name (git-file-name name version))
     (sha256
      (base32
       "111xx222cilx333nj444d4gf8pficjj40jnmfkiwl7ngznjxwkyw"))))))
