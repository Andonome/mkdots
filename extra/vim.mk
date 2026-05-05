#plugins += https://github.com/alx741/vinfo.git
#plugins += https://github.com/jamessan/vim-gnupg.git

################

default += ${HOME}/.vim/doc/tags

plugin_dir = $(basename $(notdir $(plugins)))
plugin_path = $(patsubst %,extra/vim/%,$(plugin_dir) )
ignored += extra/vim/

vpath % $(plugin_path)

doc_paths = $(patsubst %,%/doc,$(plugin_path))
docs = $(foreach doc, $(doc_paths), $(wildcard $(doc)/*) )
doc_copies = $(patsubst %,${HOME}/.vim/doc/%,$(notdir $(docs)))

auto_paths = $(patsubst %,%/autoload,$(plugin_path))
autos = $(foreach auto, $(auto_paths), $(wildcard $(auto)/*) )
auto_copies = $(patsubst %,${HOME}/.vim/autoload/%,$(notdir $(autos)))

script_paths = $(patsubst %,%/plugin,$(plugin_path))
scripts = $(foreach script, $(script_paths), $(wildcard $(script)/*) )
script_copies = $(patsubst %,${HOME}/.vim/plugin/%,$(notdir $(scripts)))

################

################

$(doc_copies): ${HOME}/.vim/doc/%: doc/% | ${HOME}/.vim/doc/
	cp -lf $< $@

$(auto_copies): ${HOME}/.vim/autoload/%: autoload/% | ${HOME}/.vim/autoload/
	cp -rlf $< $@

$(script_copies): ${HOME}/.vim/plugin/%: plugin/% | ${HOME}/.vim/plugin/
	cp -rlf $< $@

################

${HOME}/.vim/doc/tags: $(wildcard ${HOME}/.vim/doc/*.txt)
	vim -c 'helptags $(dir $<)' -c q

$(plugin_path) &: | extra/vim/
	$(foreach url,$(plugins), \
		git clone $(url) extra/vim/$(basename $(notdir $(url))); )

$(auto_copies) $(doc_copies) $(script_copies): | $(plugin_path)

default += $(auto_copies) $(doc_copies) $(script_copies)

