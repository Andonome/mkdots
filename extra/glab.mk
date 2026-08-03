token_name = gitlab-token

default += $(HOME)/.config/glab-cli/config.yml
default += $(HOME)/.config/glab-cli/aliases.yml

$(HOME)/.config/glab-cli/config.yml: $(HOME)/.password-store/$(token_name).gpg $(MAKEFILE_LIST)
	test -f $@ || pass $(token_name) | glab auth login --stdin
	glab config --global set glamour_style dark
	glab config --global set editor ${VISUAL}
	glab config --global set check_update false
	glab config --global set browser qutebrowser
	glab config --global set display_hyperlinks false

$(HOME)/.config/glab-cli/aliases.yml: $(HOME)/.config/glab-cli/config.yml
	glab alias set c 'issue list'
	glab alias set s 'issue view $1 --comments'
	glab alias set r 'issue note $1 --message'

creds += $(HOME)/.config/glab-cli/config.yml
default += $(HOME)/.config/glab-cli/aliases.yml

