#!/bin/sh

set -e

sv="$(command -v sv 2>/dev/null || command -v systemctl 2>/dev/null )"
FZF="$(command -v sk 2>/dev/null|| command -v fzf 2>/dev/null)"

transmission_home="$(awk '{FS=":"}; /transmission/ {print $6}' /etc/passwd)"
dir=/mnt/share
test -d "$dir" || dir="$transmission_home"

source='gopher://bay.parazy.de:666/1/q.dcgi?'

category=Series

while getopts 'npc:' OPTION; do
  case "$OPTION" in
    p)
      printout=true
      ;;
    c)
      category="${OPTARG}"
      ;;
    n)
      unset category
      ;;
    ?)
      echo "flag not recognized" >&2
      exit 1
      ;;
  esac
done
shift "$(($OPTIND -1))"

query="$@"

[ -n "$query" ] || read -p "Query? " query

tmp=$( mktemp --suffix=.rec )

request="$( echo $query | sed 's/ /%09/g' )"

curl -s "${source}${request}" | sed -r -n 's/^iName: (.*)\sErr.*/\nName: \1/p; s/.*URL:(.*)\sbay.*/URL: \1/p' > "$tmp"

get_names(){
    recsel "$tmp" -CP Name | "$FZF" --multi
}

get_magnet(){
    echo "$pick" | while read -r line ; do
        recsel "$tmp" -e "Name = \"$line\"" -CP URL
    done
}

download_link(){
    if [ -z "$category" ] ; then 
        category="$( basename -s "$dir"/* | "$FZF" )"
    fi

    sudo $sv start transmission-daemon
    for m in "$magnet" ; do
        transmission-remote -a "$m" -w /mnt/share/"$category"
    done
}

pick="$(get_names)"

magnet="$(get_magnet)"

if [ "$printout" = "true" ]; then
    echo "$magnet"
    [ -z "$WAYLAND_DISPLAY" ] || echo "$magnet" | wl-copy
    exit 0
fi

download_link

rm "$tmp"

