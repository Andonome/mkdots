
default += $(HOME)/.config/glab-cli/config.yml

$(HOME)/.config/glab-cli/config.yml: extra/glab-cli/config.yml $(HOME)/.config/glab-cli/aliases.yml
	$(CP) $< $@
	chmod -R 600 $(@D)

