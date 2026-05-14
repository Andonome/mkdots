CP = ln -f
.PHONY: output
output: .default

include extra/secrets.mk
include extra/cron.mk
include extra/glab.mk
include extra/mime.mk
include extra/ssh.mk
include extra/tut.mk
include extra/vim.mk

default += $(live_home) $(live_configs) $(live_scripts)

repo_home != find home/ -mindepth 1 -type f
live_home = $(patsubst home/%, $(HOME)/.%, $(repo_home))
$(live_home): $(HOME)/.%: home/%
	@mkdir -p $(@D)
	$(CP) $< $@

repo_configs != find config/ -mindepth 1 -type f
live_configs = $(patsubst config/%, $(HOME)/.config/%, $(repo_configs))
$(live_configs): $(HOME)/.config/%: config/%
	@mkdir -p $(@D)
	$(CP) $< $@

repo_scripts = $(wildcard scripts/*)
live_scripts = $(patsubst scripts/%, $(HOME)/.local/bin/%, $(repo_scripts))
$(HOME)/.local/bin/:
	mkdir -p $@
$(live_scripts): $(HOME)/.local/bin/%: scripts/% | $(HOME)/.local/bin/
	mkdir -p $(@D)
	$(CP) $< $@

%/:
	mkdir -p $@

gitignore = .git/info/exclude
$(gitignore): $(ignored)
	echo $(ignored) | tr ' ' '\n' > $@

default += $(gitignore)

default += $(secrets)

$(secrets): $(HOME)/.%: $(HOME)/.password-store/%.gpg
	@mkdir -p $(@D)
	@chmod 700 $(@D)
	gpg --quiet --decrypt $< > $@ 
	chmod 600 $@

creds += $(secrets)

.PHONY: safe
safe:
	shred -f $(creds)
	$(RM) $(creds)


.PHONY: .default
.default: $(default)
