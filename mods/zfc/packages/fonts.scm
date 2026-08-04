(define-module (zfc packages fonts)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix build-system font))

(define-public font-lxgw-markergothic
  (package
    (name "font-lxgw-markergothic")
    (version "1.003")
    (source
     (origin
       (method url-fetch)
	   (uri (string-append
			 "https://github.com/lxgw/LxgwMarkerGothic/releases/download/v"
			 version "/LxgwMarkerGothic-v" version ".zip"))
       (sha256
        (base32
         "0i3lym3qas43yyiqajxqd84ml1y0zcdhffm194ljmim4n30l13w5"))))
    (build-system font-build-system)
	(home-page
	 "https://github.com/lxgw/LxgwMarkerGothic")
	(synopsis
	 "An open-source Chinese font derived from Tanugo.")
	(description
	 "An open-source Chinese font derived from Tanugo.")
	(license license:silofl1.1)))
