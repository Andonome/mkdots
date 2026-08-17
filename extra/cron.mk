default += cron.txt

ignored += cron.txt

cron.txt: $(wildcard extra/cron/*)
	sed 'i\ ' $^ > $@
	sed -i "1 i\ " $@
ifneq (${DISPLAY},)
	sed -i "1 i DISPLAY=$(DISPLAY)" $@
endif
	sed -i "1 i PATH=$(PATH)" $@
	sed -i "1 i HOME=$(HOME)" $@
	sed -i "1 i MAIL=$(MAIL)" $@
	sed -i "1 i MAILTO=$(USER)" $@
	crontab cron.txt
