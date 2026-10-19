#!/bin/sh
failures=0
set -e

. three_strikes

[ -z "$1" ] && \
	echo Give me a remote ical file && \
	exit 1

TMP=$(mktemp)
CALDATA=~/.local/share/calcurse/apts

cp "$CALDATA" "$CALDATA".bak

get_events(){
		curl -s "$1" | calcurse -q -i - -c "$TMP"
        grep -vf "$CALDATA" "$TMP" >> "$CALDATA" || true
}

get_events "$1"

rm "$TMP"
