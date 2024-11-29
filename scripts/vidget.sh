#!/bin/sh

command -v youtube-dl 2&1>/dev/null && dl=youtube-dl
command -v yt-dlp >/dev/null && dl=yt-dlp


mkdir -p ~/vids

download_listed_video_then_remove_from_list(){
    count=0
    [ -f .list ] && cat .list | while read link
    do
        count=$(( count + 1 ))
        if [ "$count" -lt 3 ]; then
            $dl "$link" && \
            line="$(echo $link | sed 's#/#\\/#g')" && \
            sed -i "/$line/d" .list 
        fi
    done
}

warn_the_user_if_more_than_seven_videos_are_in_the_list(){
    vidCount="$(wc -l ~/vids/.list  | cut -d' ' -f1)" 
    if [ "$vidCount" -gt 5 ]; then
        export DISPLAY=:0
        notify-send "Vidlist at $vidCount"
    fi
}

warn_the_user_if_more_than_seven_videos_are_in_the_list

[ "$(basename "$0")" = "vidget.sh" ] && \
    pgrep $dl && \
    exit 0

cd ~/vids && \
    download_listed_video_then_remove_from_list
