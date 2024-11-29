#!/bin/sh

# Dependencies: 
# - curl
# - espeak

set -u
set -e

CACHE=/tmp/rain

[ -f $CACHE ] || echo 'warnings=0' > $CACHE

. $CACHE

city="$(ls -l /etc/localtime  | rev | cut -d '/' -f 1 | rev)"

[ ! -z "$city" ]

check_for_rain(){
	precipitation="$(curl -s wttr.in/$city?format=%p  | tail -c -3 | head -c -2)"
	
	if [ "$precipitation" -gt 0 ]; then
			espeak "Ahem"
			espeak "It might be about to rain"
			sleep 1
			espeak "Check the laundry."
	else
		warnings=0
	fi
}


if [ "$warnings" -gt 2 ]; then
	warnings=0
else
	warnings="$(( warnings + 1 ))"
	check_for_rain
fi

echo "warnings=$warnings" > $CACHE
