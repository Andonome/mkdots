### Ucomment to use the makefile.
default += cron.txt

ignored += cron.txt

cron.txt: $(wildcard extra/cron/*)
	cat $^ > $@
	grep -q '^PATH'   $@ || sed -i "1 i PATH=$(PATH)" $@
	grep -q '^HOME'   $@ || sed -i "1 i HOME=$(HOME)" $@
	grep -q '^MAILTO' $@ || sed -i "1 i MAILTO=$(USER)" $@
	crontab cron.txt
