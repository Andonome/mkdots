#!/bin/sh

[ -z "$1" ] && echo "This script tries to download latex files with tlmgr. Give it a texfile with packages as the first argument."

install_list=$(mktemp)

check_local(){
		tlmgr search --file "/$1.sty$"  | grep -q ':$' && \
		printf "$1 found installed\n"
}

check_remote(){
		package="$(tlmgr search --global --file "/$1.sty$"  | grep ':$' | sed 's/://')"
		[ -z "$package" ] && printf "problem: cannot find '${1}'\n" || \
		printf "$package\n" >> $install_list
}

install_all(){
	echo starting install
	cat $install_list | while read -r line; do
		tlmgr install "$line"
	done
}

get_list_of_required_packages_from_file(){
    grep -Po '(RequirePackage|usepackage).*{\K[^ }]+' "$1"
}

and_check_if_they_are_installed_or_can_be(){
    while read -r line; do
        check_local "$line" || check_remote "$line"
    done
}

get_list_of_required_packages_from_file "$1" | and_check_if_they_are_installed_or_can_be

if [ "$(wc -l < $install_list" -gt 0 ]; then
	printf "\n\n===========\nNeed to install these files:\n\n"
	cat "$install_list"
    read -p 'Proceed?  ' reply
	echo "$reply" | grep -iq y && \
    {
        install_all 
        rm "$install_list"
    } || {
        echo 'Stopping...' && \
        echo "Your packages list at $install_list."
    }
fi

