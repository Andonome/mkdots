### Uncomment to use the makefile.
default += cron.txt

ignored += cron.txt

cron.txt: $(wildcard extra/cron/*)
	cat $^ > $@
	sed -i "1 i\ " $@
ifneq (${DISPLAY},)
	grep -q '^DISPLAY' $@ || sed -i "1 i DISPLAY=$(DISPLAY)" $@
endif
	grep -q '^PATH'   $@ || sed -i "1 i PATH=$(PATH)" $@
	grep -q '^HOME'   $@ || sed -i "1 i HOME=$(HOME)" $@
	grep -q '^MAILTO' $@ || sed -i "1 i MAILTO=$(USER)" $@
	crontab cron.txt
