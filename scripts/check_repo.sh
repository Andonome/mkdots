#!/bin/sh

command -v tellme.sh >/dev/null ||  {
    echo This script needs the tellme.sh script.
    exit 1
}

[ -z "$1" ] && {
    echo Give me a git repo path.
    exit 1
}

repo="$1"

no_change_in_repo(){
    response="$(timeout 5 git -C "$repo" fetch --porcelain 2>/dev/null)" && \
    echo "$response" | grep -v -q ref
}


note_repo_change(){
    basename "$repo"
    git -C "$repo" show origin/HEAD --quiet --format=reference
}

###############

no_change_in_repo "$1" || note_repo_change | tellme.sh

