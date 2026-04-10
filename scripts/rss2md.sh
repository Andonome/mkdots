#!/bin/sh

set -e

[ ! -z "$1" ] || { echo "Which rss feed?" && exit 1 ;}

no_lines=${2:-80}

RSStoMarkdown(){
    sed -nr 's/.*<title>(.*)<\/.*/\n**\1**/p ; s/.*<pub\w+>([^+<]+).*/- \1/p ; s/.*<updated>([^+<]+).*/- \1/p' \
    | sed 's/&amp;/\&/g'
}

get_http_feed(){
    curl -s -L "$1" | RSStoMarkdown
}

use_file_feed(){
    test -f "$1" && RSStoMarkdown < "$1"
}

show_feed(){
    echo "${1%%:*}" | grep -q http && get_http_feed "$1" || use_file_feed "$1" \
        || { echo "What is $1?" && exit 1 ;}
}

######


for feed in $@; do 
    show_feed "$feed"
done
