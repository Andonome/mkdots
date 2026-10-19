#!/bin/sh
failures=0

set -e

. three_strikes

dl='yt-dlp'
options='-ic --embed-metadata'

vidlist=~/.cache/vidlist.txt

download_listed_video_then_remove_from_list(){
    count=0
    [ -f "$vidlist" ] && cat "$vidlist" | while read link
    do
        count=$(( count + 1 ))
        if [ "$count" -lt 3 ]; then
            $dl $options "$link" && \
            line="$(echo $link | sed 's#/#\\/#g')" && \
            sed -i "/$line/d" "$vidlist" 
        fi
    done
}

##########

mkdir -p ~/vids

[ "$(basename "$0")" = "vidget.sh" ] && \
    pgrep $dl && \
    exit 0

cd ~/vids && \
    download_listed_video_then_remove_from_list
