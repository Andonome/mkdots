#!/bin/sh

set -e
set -x

sv="$(command -v sv systemctl)"
FZF="$(command -v sk fzf | head -1)"

source='gopher://bay.parazy.de:666/1/q.dcgi?'

category=Series

while getopts 'p:c:' OPTION; do
  case "$OPTION" in
    p)
      printout=true
      ;;
    c)
      category="${OPTARG}"
      ;;
    ?)
      echo "flag not recognized" >&2
      exit 1
      ;;
  esac
done
shift "$(($OPTIND -1))"

query="$@"

[ -z "$query" ] && read -p "Query? " query

dl_dir=/mnt/share/Series

tmp=$( mktemp --suffix=.rec )

request="$( echo $query | sed 's/ /%09/g' )"

curl -s "${source}${request}" | sed -r -n 's/^iName: (.*)Err.*/\nName: \1/p; s/.*URL:(.*)bay.*/URL: \1/p' > "$tmp"

get_names(){
    recsel "$tmp" -CP Name | "$FZF"
}

get_magnet(){
    recsel "$tmp" -e "Name = \"$pick\"" -P URL
}

pick="$(get_names)"
magnet="$(get_magnet)"

if [ "$printout" = "true" ]; then
    echo "$magnet"
    [ -z "$WAYLAND_DISPLAY" ] || echo "$magnet" | wl-copy
    exit 0
fi

if [ -z "$category" ] ; then 
    category="$( basename -s /mnt/share/* | "$FZF" )"
fi

sudo $sv start transmission-daemon

transmission-remote -a "$magnet" -w /mnt/share/"$category"

rm "$tmp"
