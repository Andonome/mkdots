
secrets += $(HOME)/.config/aerc/accounts.conf
secrets += $(HOME)/.config/msmtp/config
secrets += $(HOME)/.mbsyncrc
default += extra/cron/email
ignored += extra/cron/email

extra/cron/email:
	echo '0 9-18 * * * mbsync -a' > $@
	echo '10 9-18 * * * msmtpq --q-mgmt -r' >> $@

