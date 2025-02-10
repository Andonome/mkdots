#!/bin/sh

set -e

#############################

watched_list=~/.local/watched

videos_location=/mnt/share/

# plocate needs to be able to see the videos' location.
# You can make sure it scans the location by editing
# /etc/updatedb.conf

#############################

select_episode(){
	plocate --regex '.mp4$|.mkv$|.wmv$|.flv$|.webm$|.mov$|.avi$' "^$videos_location" | \
    grep -vf "$watched_list" | \
    while read line; do
        basename "$line"
    done | \
    rofi -i -dmenu | \
    sed 's/\[/\\[/g'
}

play_episode(){
	mpv --no-terminal "$(plocate "$selection" | head -1)" || {
        echo cannot find "$selection"
        exit 1
    }
}

put_in_watched_list(){
    echo "$selection" >> "$watched_list"
}

selection="$(select_episode)"

play_episode && put_in_watched_list
