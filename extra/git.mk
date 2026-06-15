default += ${HOME}/.gitconfig

${HOME}/.gitconfig: $(MAKEFILE_LIST)
	git config --global user.name "Malin Freeborn"
	git config --global user.email malinfreeborn@posteo.net
	git config --global user.signingkey 024C6B1C84449BD1CB4DF7A152295D2377F4D70F
	git config --global commit.gpgsign true
	git config --global core.excludesfile "${HOME}/.gitignore_global"
	git config --global pull.rebase false
	git config --global advice.addignoredfile false
	git config --global protocol.file.allow always
	git config --global init.defaultbranch master
	git config --global branch.sort "-comitterdate"
	git config --global merge.conflictstyle diff3
	git config --global credential.helper cache
	git config --global credential.https://repo.studiobedem.rs.helper "!tea login helper"

