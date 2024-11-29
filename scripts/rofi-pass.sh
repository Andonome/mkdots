#!/bin/sh

pass_store=~/.password-store

sanity_check(){
    command -v $1 >/dev/null || (
        echo "You must install $1"
        exit 1
    )
}

set_selector_if_program_exists(){
    command -v "$1" > /dev/null  && selector="$1 $2"
}

if [ -z "$DISPLAY" ]; then
    set_selector_if_program_exists sk || \
        set_selector_if_program_exists fzy || \
        set_selector_if_program_exists fzf
    fail_sender='echo'
else
    set_selector_if_program_exists "rofi" 'rofi -dmenu "$@"' || \
        set_selector_if_program_exists dmenu || \
        (
            echo "Cannot find anything to select a key. Install dmenu." 
            exit 1
        )
    fail_sender='notify-send'
fi

list_keys(){
    find -L . -mindepth 1 -type f -name "*.gpg" | \
        sed 's/\.\///' | \
        sed 's/.gpg//'
}

####################

set -e

sanity_check pass

cd "$pass_store"

password="$(list_keys | $selector)"

pass -c "$password" || $fail_sender 'Cannot decrypt'

