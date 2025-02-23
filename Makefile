CP = ln -f
.PHONY: output
output: .default

include $(wildcard extra/*.mk)

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
$(HOME)/.locale/bin/:
	mkdir -p $@
$(live_scripts): $(HOME)/.local/bin/%: scripts/% | $(HOME)/.locale/bin/
	mkdir -p $(@D)
	$(CP) $< $@

gitignore = .git/info/exclude
$(gitignore): $(ignored)
	echo $(ignored) | tr ' ' '\n' > $@

default += $(gitignore)

.PHONY: secrets
secrets: $(secrets)

.PHONY: .default
.default: $(default)
