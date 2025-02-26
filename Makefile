output: README.md home/ config/ scripts/mkdots
	mv extra/Makefile .
	git add .
	git status

HOSTNAME != cat /etc/hostname

.git/HEAD: /etc/hostname .git/ extra/cron/tab
	git switch -c $(HOSTNAME)

config/: .git/HEAD
	mkdir $@
	mkdir -p $(HOME)/.local/bin
	@test ! -f $(HOME)/.bashrc || cp $(HOME)/.bashrc home/bashrc
	@test ! -f $(HOME)/.profile || cp $(HOME)/.profile home/profile
	@test ! -f $(HOME)/.gitconfig || cp $(HOME)/.gitconfig home/gitconfig
	@echo $(PATH) | grep -qF '.local/bin' || echo 'You do not have ~/.local/bin in your $$PATH.  Add it to your path by adding `PATH=$$PATH:$$HOME/.local/bin` to your ~/.bashrc'

home/: .git/HEAD
	mkdir $@
	@test ! -f $(HOME)/.bashrc || cp $(HOME)/.bashrc home/bashrc
	@test ! -f $(HOME)/.profile || cp $(HOME)/.profile home/profile

scripts/mkdots:
	mkdir $(@D)
	printf '%s\n' '#!/bin/sh' > $@
	printf '%s\n' 'cd $(PWD) || exit 1' >> $@
	printf '%s\n' 'make' >> $@
	printf '%s\n' 'git diff --quiet || ( git add -p && git commit && git push )'
	chmod u+x $@
	mkdir -p $(HOME)/.local/bin
	@echo $(PATH) | grep -qF '.local/bin' || echo 'You do not have ~/.local/bin in your $$PATH.  Add it to your path by adding `PATH=$$PATH:$$HOME/.local/bin` to your ~/.bashrc'

README.md:
	@printf "%s\n\n" "# $(USER) dotfiles" > $@
	@printf "%s\n" "These are my dots.  There are many like them, but these ones are mine." >> $@

.git/:
	git init

extra/cron/tab:
	mkdir -p $(@D)
	crontab -l > $@ || exit 0
