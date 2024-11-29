#!/bin/sh

set -e

[ -z "$1" ] && \
	echo Give me a remote ical file && \
	exit 1

TMP=$(mktemp)
CALDATA=~/.local/share/calcurse/apts

cp "$CALDATA" "$CALDATA".bak

get_events(){
		curl -s "$1" | sed '/DTEND/d' > "$TMP"
		calcurse -qi "$TMP"
}

deduplicate_events(){
		sort "$CALDATA" | uniq > "$TMP"
		mv "$TMP" "$CALDATA"
}

get_events "$1"
deduplicate_events
