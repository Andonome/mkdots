#!/bin/sh

set -e

art2db () 
{ 
    title="$(lowdown -X title "$1" | jq -r || echo None in $1)";
    date="$(lowdown -X date "$1" | cut -dT -f1)";
    wc="$(wc -w "$1" | cut -d' ' -f1)";
    tags="$(lowdown -X tags "$1" | jq -r '.[]')";
    content="$(sed '1,5d' "$1")"

    recins -f Title -v "$title" \
        -f File -v "$1" \
        -f Date -v "$date" \
        -f Tags -v "$tags" \
        -f WC -v "$wc" \
        -f Content -v "${content}" \
        articles.rec
}

[ -f articles.rec ] || (
    touch articles.rec
    echo articles.rec >> .git/info/exclude
)

for file in *.md; do
    count="$(recsel -e "File = '${file}'" -c articles.rec)"
    test "$count" -eq "1" || art2db "$file"
done

