#!/bin/sh

set -e

[ -z "$1" ] && target_files="$(dir *.md)" || \
    target_files="$@"

art2db () 
{ 
    title="$(lowdown -X title "$1" | jq -r || echo None in $1)"
    date="$(lowdown -X date "$1" | cut -dT -f1)"
    tags="$(lowdown -X tags "$1" | sed 's/^- /Tag: /')"
    content="$(sed '1d;1,/---/d' "$1" | sed '0,/.*/n;  s/^/+ /g')"
    wc="$(printf "%s" "$content" | wc -w )"

printf "\n%s\n" "Title: $title
File: $1
Date: $date
Wordcount: $wc
$tags
Content: $content"
}

pick_article(){
    title="$(recsel -t Post articles.rec -CP Title | $FZY )" && \
        recsel -t Post articles.rec -e "Title = '${title}'" -P Content | $PAGER
}

###############

FZY="$(command -v fzf sk fzy | head -1)"

[ -f articles.rec ] || (
    touch articles.rec
)

[ ! -f .git/info/exclude ] || \
    grep -q articles.rec .git/info/exclude || \
    echo articles.rec >> .git/info/exclude

{
    printf '\n\n%s\n\n' '%rec: Post'

    for file in $target_files ; do
        art2db "$file"
    done

} | recsel -d | tee articles.rec | recinf

[ -z "$FZY" ] || pick_article
