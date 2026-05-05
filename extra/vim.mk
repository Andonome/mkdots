default += ${HOME}/.vim/doc/tags

${HOME}/.vim/doc/tags: $(wildcard ${HOME}/.vim/doc/*.txt)
	vim -c 'helptags $(dir $<)' -c q
