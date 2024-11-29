default += $(HOME)/.config/glab-cli/config.yml $(HOME)/.config/glab-cli/aliases.yml

$(HOME)/.config/glab-cli/%.yml: extra/glab-cli/%.yml
	mkdir -p $(@D)
	chmod 600 $^
	$(CP) $< $@
