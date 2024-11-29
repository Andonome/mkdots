#!/bin/bash

family="$(grep '^192' /etc/hosts | awk '{print $2}')"

timeout 2 curl -s wttr.in/Moon

[ $(date +%u) = 7 ] && \
	( task +tmp delete 
	task +tmp purge )

import_events.sh https://dmz.rs/events.ical

$HOME/.local/bin/clean.sh

logfile="$(ls /tmp/CLEAN-* | head -n1)"

for i in $family
do
	sleep 2
	if [ "$HOSTNAME" != "$i" ] && ping -c 1 $i >/dev/null; then
		ssh $i 'bash ~/.local/bin/clean.sh'
		echo -e "\n\n# $i fixes" >> "$logfile"
		ssh $i "[ -f $logfile ] && cat $logfile" >> $logfile
	fi
done

[ -f "$logfile" ] && cat "$logfile"

command -v yay >/dev/null && yay -Pw | tee -a "$logfile"
