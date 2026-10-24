default += ${XDG_CONFIG_HOME}/task/local.rc

task = task rc.confirmation:no rc.verbose:nothing rc.hooks:off rc.gc=0 config

${XDG_CONFIG_HOME}/task/local.rc: | ${XDG_CONFIG_HOME}/task/holidays.sh
	cd $(@D) && $|
	${task} rc:$@ sync.git.local_path ${XDG_DATA_HOME}/taskwarrior
	${task} rc:$@ sync.git.branch master
	${task} rc:$@ sync.encryption_secret $(shell pass task)
	${task} rc:$@ sync.git.remote cirrus

