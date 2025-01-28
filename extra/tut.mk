$(HOME)/.config/tut/accounts.toml: $(HOME)/.password-store/config/tut/accounts.toml.gpg
	pass config/tut/accounts.toml > $@

gpg_files += $(HOME)/.config/tut/accounts.toml
