#!/bin/sh

[ ! -z "$1" ] || {
    echo "Give me a youtube URL"
    exit 1
}

TMPFILE=$(mktemp)

URL="$(printf "$1" | sed 's/yt.artemislena.eu/www.youtube.com/')"

copy_url(){
    for x in $(seq 1 5); do
        curl -s "$URL" | tee $TMPFILE | grep -q channelId && \
            break || \
            echo "URL failure no. $x."
    done
}

get_channel_id(){
	cat $TMPFILE | \
	tr ',' '\n' | \
	grep channelId | \
	tr '"' '\n' | \
	grep '^U' | \
	head -1
}

get_feed_url(){
	FEED_URL="https://www.youtube.com/feeds/videos.xml?channel_id=$(get_channel_id)"
}

get_channel_name(){
	curl -s "$FEED_URL" | \
	grep -m1 title | \
	cut -d '>' -f2 | \
	cut -d'<' -f1
}

get_feed_line(){
	get_feed_url
	CHANNEL_NAME="$(get_channel_name)" && rm "$TMPFILE"
	echo "URL: $FEED_URL"
	echo "Name: $CHANNEL_NAME"
    echo "Category: Video"
}

####################

copy_url "$1"

get_feed_line

