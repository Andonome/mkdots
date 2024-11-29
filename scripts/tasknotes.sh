#!/bin/sh
location="~/.local/state/task/notes"
[ -e "$location" ] || mkdir "$location"

[ "$1" = "show" ] && {
	{ tu="$(task "$2" uuids).md" || echo "Input a task number" ; }
	{
		[ -e "$location"/"$tu" ] && cat "$location"/"$tu" && exit 0 
	} || \
		{
		echo "No notes" 
		exit 1 
	}
}

[ "$1" = "rm" ] && {
	{ tu="$(task "$2" uuids).md" || echo "Input a task number" ; }
	{
		[ -e "$location/$tu" ] && rm "$location/$tu" && exit 0 
	} || \
		{
		echo "No notes" 
		exit 1 
	}
}

tu="$(task "$1" uuids).md" || echo "Something went wrong with identifying that task's number."
[ ! -e "$location"/"$tu" ] && task "$1" minimal | tail -3 | head -1 > "$location"/"$tu" && echo '' >> "$location"/"$tu"

vim "$location"/"$tu"
