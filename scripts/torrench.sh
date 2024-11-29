#!/bin/bash
# search for torrents, e.g.
# ./torrench.sh nina paley
#
# If you haven't set up transmission before, install it (it's usually called 'transmission-cli'.
# The default download directory can be changed below, or edit '/var/lib/transmission/.config/transmission-daemon/settings.json' and change 'download-dir' line, and remove the last line in this script.)

urldecode() { : "${*//+/ }"; echo -e "${_//%/\\x}"; }

source=leet

while getopts 'kp' OPTION; do
  case "$OPTION" in
    p)
      printout=true
      ;;
    k)
      source=kikass
      ;;
    ?)
      echo "flag not recognized" >&2
      exit 1
      ;;
  esac
done
shift "$(($OPTIND -1))"

dl_dir=/mnt/share/Series

# Replace spaces with '+' sign
query=$(printf '%s' "$*" | tr ' ' '+' )

if [ "$source" = "leet" ]; then
    movie="$(curl -s https://www.1337xx.to/search/"$query"/1/ | grep --max-count=8 -Eo "torrent/[0-9]{7}/[a-zA-Z0-9?%-]*/"| fzy)"

    # get a magnet link from 1337.wtf
    magnet="$(curl -s https://www.1337xx.to/"$movie" | grep --max-count=1 -Po "magnet:\?xt=urn:btih:[a-zA-Z0-9]*")"
else
    full_page="$(curl -sA "Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101 Firefox/81.0" "https://kickassz.com/usearch/$query")"
    selection="$(echo "$full_page" | grep cellMainLink | cut -d'>' -f2 | cut -d'<' -f1 | sk)"
    basic_magnet="$(echo "$full_page" | grep -FA30 -m1 "$selection" | grep -oP '=\Kmagnet.*' | cut -d'"' -f1)"
    magnet="$(urldecode "$basic_magnet")"
fi

[ -z "$magnet" ] && exit 0

magnet="$(echo $magnet | cut -d'&' -f1)"

if [ "$printout" ]; then
	printf "$magnet" | xclip -selection clipboard
else
	sudo systemctl start transmission
	transmission-remote -a "$magnet"  -w $dl_dir
fi
