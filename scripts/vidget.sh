#!/bin/sh

command -v youtube-dl 2&1>/dev/null && dl=youtube-dl
command -v yt-dlp >/dev/null && dl='yt-dlp' && options='-ic --embed-metadata'

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

warn_the_user_if_more_than_seven_videos_are_in_the_list(){
    vidCount="$(wc -l "$vidlist"  | cut -d' ' -f1)" 
    if [ "$vidCount" -gt 5 ]; then
        export DISPLAY=:0
        notify-send "Vidlist at $vidCount"
    fi
}

##########

mkdir -p ~/vids

warn_the_user_if_more_than_seven_videos_are_in_the_list

[ "$(basename "$0")" = "vidget.sh" ] && \
    pgrep $dl && \
    exit 0

cd ~/vids && \
    download_listed_video_then_remove_from_list
