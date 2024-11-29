#!/bin/sh
# Dependencies: mpv, then either btfs or peerflix

# First decide on a player
if [ $(command -v mpv) ]; then
	player=mpv
elif [ $(command -v vlc) ]; then
	player=vlc
else
	echo No video player found
	exit 1
fi

query=$(printf '%s' "$*" | tr ' ' '+' )
movie=$(curl -s https://www.1337xx.to/search/$query/1/ | grep --max-count=1 -Eo "torrent/[0-9]{7}/[a-zA-Z0-9?%-]*/")

# get a magnet link from 1337.wtf
magnet=$(curl -s https://www.1337xx.to/$movie | grep --max-count=1 -Po "magnet:\?xt=urn:btih:[a-zA-Z0-9]*")
[ -z "$magnet" ] && echo no torrent found && exit 0
echo "$magnet"
if [ $(command -v peerflix) ]; then
	peerflix --$player "$magnet"
elif [ $(command -v btfs) ]; then
	mkdir -p /tmp/notflix-video
	# start with cleaning up any old files mounted in /tmp/notflix-video
	[ -e /tmp/notflix-video/* ] && fusermount -uz /tmp/notflix-video
	btfs --data-directory=/tmp/btfs "$magnet" /tmp/notflix-video
	while [ -z "$video" ]; do
		video="$(find /tmp/notflix-video -type f -size +5M -iname "*.mkv" -o -iname "*.mp4" -o -iname "*.webm" -o -iname "*.avi" -o -iname "*.ogg"| head -n1)"
		sleep 1
	done
	echo got video
	$player "$video"
	fusermount -u /tmp/notflix-video
else
	echo install peerflix or btfs
fi
