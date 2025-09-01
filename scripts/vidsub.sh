#!/bin/sh

set -e

[ ! -z "$1" ] || {
    echo "Give me a youtube URL"
    exit 1
}

URL="$1"

CHANNEL_ID="$(curl -s "$URL" | tr ',' '\n'  | grep -Po 'channelId":"\K[\w+-]+' | tail -1)"
FEED_URL="https://www.youtube.com/feeds/videos.xml?channel_id=$CHANNEL_ID"
CHANNEL_NAME="$(curl -s "$FEED_URL" | grep -m 1 -Po 'title\>\K[\w\s]+')"

#printf '%s "%s"\n' "$FEED_URL" "$CHANNEL_NAME"

echo ""
echo "URL: $FEED_URL"
echo "Name: $CHANNEL_NAME"
echo "Category: Videos"
echo "Rating: 3"
echo "Working: yes"
