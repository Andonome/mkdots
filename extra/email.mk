extra/cron.mk: extra/cron/email

secrets += $(HOME)/.config/aerc/accounts.conf
secrets += $(HOME)/.config/msmtp/config
secrets += $(HOME)/.mbsyncrc
ignored += extra/cron/email

extra/cron/email:
	echo '0 9-18,19-3/3 * * * mbsync -a' > $@
	echo '10 9-18 * * * msmtpq --q-mgmt -r' >> $@

