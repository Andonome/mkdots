#!/bin/sh

set -e

timeout=4

find_links(){
    echo "$1"
    sed '/```/,//d' "$1" | \
    sed -nr 's/.*\[.+\]\(([^ )]+).*/\1/p ; s/^\[[^\^]*\]:\s(.*)/\1/p'
}

check_link(){
    while read link; do
        if [ "${link##*:*}" ]; then
            check_file "$link" "$file"
        else
            prefix="${link%%:*}"
            case "${prefix}" in 
                http) check_http_link "$link"
                ;;
                https) check_http_link "$link"
                ;;
                gemini) check_gemini_link "$link"
                ;;
                mailto) echo "ignoring email: $link"
                ;;
                magnet) echo "ignoring torrent: $link"
                ;;
                *) echo "$file: unknown protocol $link"
                ;;
            esac
        fi || dead_link_error "$link" "$file"
    done
}

dead_link_error(){
    echo "$2: $1"
}

check_file(){
    path="${1#/}"
    path="${path%#*}"
    test -f "$path" \
    || test -f "$path".md \
    || (
        cd "$(dirname "$2")" && \
        test -f "$path" || test -f "$path".md
    )
}

check_gemini_link(){
	gemget --max-time "$timeout" "$1" -o- >/dev/null
}

check_http_link(){
    timeout=$(( timeout + 1 ))
	curl --connect-timeout "$timeout" -Is "$1" >/dev/null
}

check_markdown_links(){
    find_links "$1" | check_link
}

#################

test -z "$1" && targets="*.md" || targets="$@"

for file in $targets; do
    test "${file##*.}" != "md" || check_markdown_links "$file" &
done

wait
