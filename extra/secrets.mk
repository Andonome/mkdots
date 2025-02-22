gpgid ?= 024C6B1C84449BD1CB4DF7A152295D2377F4D70F

$(HOME)/.gnupg/pubring.kbx:
	echo "$(gpgid):6:" | gpg --import-ownertrust
	gpg --receive-keys $(gpgid)

