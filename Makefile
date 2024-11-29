CP = ln -f
.PHONY: output
output: .default

include $(wildcard extra/*.mk)

default += $(live_configs) $(live_scripts)

repo_configs != find home/ -mindepth 1 -type f
live_configs = $(patsubst home/%,$(HOME)/.%,$(repo_configs))
$(HOME)/.%: home/%
	@mkdir -p $(@D)
	$(CP) $< $@

repo_scripts = $(wildcard scripts/*)
live_scripts = $(patsubst scripts/%,$(HOME)/.local/bin/%,$(repo_scripts))
$(HOME)/.local/bin/%: scripts/%
	mkdir -p $(@D)
	$(CP) $< $@

gitignore = .git/info/exclude
$(gitignore): $(ignored)
	echo $(ignored) | tr ' ' '\n' > $@

default += $(gitignore)

.PHONY: .default
.default: $(default)
