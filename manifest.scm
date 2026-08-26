(use-modules (bluebox packages blue)
			 (gnu packages password-utils)
			 (gnu packages vim)
			 (gnu packages gnupg))

(packages->manifest
 (list blue
	   ;; gnupg
	   sops
	   neovim))
