#!/bin/sh

[ -z "$1" ] && echo "Which rss feed?" && exit 1

no_lines=${2:-80}

test -f "$1" && feed="$(cat "$1")" || \
    {
        test "$(printf "%s" "$1" | head -c 4)" = http && feed="$(curl -s "$1")"
    } || \
    {
        echo "This never normally happens to me."
        exit 1
    }

echo "$feed" | tail -n +8 | \
    grep -E -m "$no_lines" -e '<title>' -e '<updated>'  | \
    awk '{getline x; print x;}1' | \
    sed -r -e 's/<\w+>//' \
        -e 's/<\/\w+>//' \
        -e 's/Z$//' \
        -e 's/&amp;quot;/"/g' | \
    while read line; do
        if [ -z "$pub_time" ]; then
            pub_time="$line"
        else
            echo "- **$pub_time** - $line"
            unset pub_time
        fi
    done

