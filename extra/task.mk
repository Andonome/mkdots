
default += ${HOME}/.config/task/local.rc

${HOME}/.config/task/local.rc: ${HOME}/.config/task/holidays.sh
	cd $(<D) && ./$(<F)

