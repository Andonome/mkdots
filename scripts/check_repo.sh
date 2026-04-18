#!/bin/sh

name="$(git config user.name)"
reponame="$(basename "$repo")"

command -v tellme.sh >/dev/null ||  {
    echo This script needs the tellme.sh script.
    exit 1
}

get_list_of_repos(){
    test -f "$1" && file "$1" | grep -q text && targets="$(cat "$1")" || {
        test -d "$1"/.git && targets="$@"
    } || {
        echo no repos specified
        exit 1
    }
}

no_change_in_repo(){
    response="$(timeout 5 git -C "$repo" fetch --porcelain 2>/dev/null)" || break && \
    echo "$response" | grep -v -q ref
}

check_my_commit(){
git show origin/HEAD --quiet --format="%an" | grep -q "$name"
}

note_repo_change(){
    git -C "$repo" show origin/HEAD --quiet --format="$reponame: %an
    %f: %b"
}


###############

get_list_of_repos "$1"

for repo in $targets; do
    no_change_in_repo "$repo" || check_my_commit || note_repo_change | tellme.sh &
done

wait
