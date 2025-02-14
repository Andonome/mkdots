token_name = gitlab-token

$(HOME)/.config/glab-cli/config.yml: $(HOME)/.password-store/$(token_name).gpg
	pass $(token_name) | glab auth login --stdin
	glab config set editor ${VISUAL}
	glab config set check_update false
	glab config set browser qutebrowser
	glab config set display_hyperlinks false

$(HOME)/.config/glab-cli/aliases.yml:
	glab alias set c 'issue list'
	glab alias set s 'issue view $1 --comments'
	glab alias set r 'issue note $1 --message'

secrets += $(HOME)/.config/glab-cli/config.yml
secrets += $(HOME)/.config/glab-cli/aliases.yml


