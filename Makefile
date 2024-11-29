output: README.md

HOSTNAME != cat /etc/hostname

.git/HEAD: /etc/hostname .git/ extra/cron/
	git switch -c $(HOSTNAME)

home/: .git/HEAD
	mkdir home/
	mkdir -p $(HOME)/.local/bin
	@test ! -f $(HOME)/.bashrc || cp $(HOME)/.bashrc home/bashrc
	@test ! -f $(HOME)/.profile || cp $(HOME)/.profile home/profile
	@echo $(PATH) | grep -qF '.local/bin' || echo 'You do not have ~/.local/bin in your $$PATH.  Add it to your path by adding `PATH=$$PATH:$$HOME/.local/bin` to your ~/.bashrc'

scripts/mkdots:
	mkdir $(@D)
	printf '%s\n' '#!/bin/sh' > $@
	printf '%s\n' 'cd $(PWD) || exit 1' >> $@
	printf '%s\n' 'make' >> $@
	printf '%s\n' 'git diff --quiet || ( git add -p && git commit && git push )'
	chmod u+x $@

README.md: home/ scripts/mkdots
	@printf "%s\n\n" "# $(USER) dotfiles" > $@
	@printf "%s\n" "These are my dots.  There are many like them, but these ones are mine." >> $@
	$(info Commit these changes with 'git commit')
	mv extra/Makefile .
	git add .

.git:
	git init

extra/cron/:
	mkdir -p $@
	crontab -l > extra/cron/tab || exit 0
