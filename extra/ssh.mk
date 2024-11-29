# Copy your ~/.ssh/config to extra/ssh/config, then uncomment the next line:
# default += $(HOME)/.ssh/config
$(HOME)/.ssh/config: extra/ssh/config
	mkdir -pm700 $(@D)
	$(CP) $< $@
	chmod 600 $@
