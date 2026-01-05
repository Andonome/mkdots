#!/bin/sh

set -e

db=~/rec/feeds.rec

rec="${2:-$db}"

[ ! -z "$1" ] || {
    echo "Give me a youtube URL"
    exit 1
}

[ -w "$rec" ] || touch "$rec"

CHANNEL_ID="$(curl -s "$1" | tr ',' '\n'  | grep -Po 'channelId":"\K[\w+-]+' | tail -1)"
URL="https://www.youtube.com/feeds/videos.xml?channel_id=$CHANNEL_ID"
Name="$(curl -s "$URL" | grep -m 1 -Po 'title\>\K[\w\s]+')"

recins --verbose -t Feed -f Name -v "${Name}" -f URL -v "${URL}" -f Category -v Videos -f Rating -v 3 -f Working -v yes "$rec"

