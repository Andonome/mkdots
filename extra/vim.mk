#plugins += https://github.com/alx741/vinfo.git
#plugins += https://github.com/jamessan/vim-gnupg.git
#plugins += https://github.com/zaid/vim-rec.git
#plugins += https://github.com/OmniSharp/omnisharp-vim.git

### Plugins ###

vimdirs = $(notdir $(basename $(plugins)))
vimpaths = $(patsubst %,${HOME}/.vim/pack/plugins/start/%, $(vimdirs) )

$(vimpaths): ${HOME}/.vim/pack/plugins/start/%: | ${HOME}/.vim/pack/plugins/start
	git clone $(filter %$(notdir $@).git,$(plugins)) $@

${HOME}/.vim/pack/plugins/start:
	mkdir -p $@

default += $(vimpaths)

################

### Tags ###

default += ${HOME}/.vim/doc/tags

${HOME}/.vim/doc/tags: $(wildcard ${HOME}/.vim/doc/*.txt)
	vim -c 'helptags $(dir $<)' -c q

