#!/bin/sh

sv="$(command -v sv systemctl)"

source='gopher://bay.parazy.de:666/1/q.dcgi?'

category=Series

while getopts 'tp' OPTION; do
  case "$OPTION" in
    p)
      printout=true
      ;;
    t)
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

[ -z "$query" ] && read -p "Query? " query

dl_dir=/mnt/share/Series

tmp=$( mktemp --suffix=.rec )

request="$( echo $query | sed 's/ /%09/g' )"

curl -s "${source}${request}" > "$tmp"

get_names(){
    sed -r -n 's/iName:(.*)\tErr.*/\1/p' "$tmp" | fzf
}

pick="$(get_names)"

magnet="$(grep -F -A5 "$pick" "$tmp" | awk '/hMagnet/ {print $3}')"

if [ "$printout" = "true" ]; then
    echo "$magnet"
    echo "$magnet" | wl-copy
    exit 0
fi

if [ -z "$category" ] ; then 
    category="$( basename -s /mnt/share/* | fzf )"
fi

sudo $sv start transmission

transmission-remote -a "$magnet" -w /mnt/share/"$category"

echo "$magnet"
