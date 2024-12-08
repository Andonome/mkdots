#!/bin/sh

location="$HOME/.local/state/task/notes"

[ -d "$location" ] || mkdir "$location"

alias tsk="task rc.verbose=nothing rc.gc=no"

pager_program="${PAGER:-less -R}"

while getopts "svrh" opt; do
  case "${opt}" in
    v)
      echo "using verbose mode"
	  DEBUG=true
      set -x
      ;;
    s)
	  show=true
      ;;
    r)
		delete_note=true
      ;;
    h)
		echo -e "Options are -v (verbose), -r (remove/ delete task notes), and -s (show)."
		exit 0
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
  esac
done

shift "$(($OPTIND -1))"

[ -z "$1" ] && echo "Give a task number" && exit 1 || tu="$(tsk uuids "$1")"

note_file="$tu.md"

task_desc="$(tsk _get "$tu".description)"

[ -z "$delete_note" ] || {
    rm "$location/$note_file"
    exit 0
    } && \
[ -e "$location/$note_file" ] && {
    [ -z "$show" ] && $pager_program "$location/$note_file" || \
    $EDITOR "$location/$note_file"
} || \
{
    [ -z "$show" ] || {
        echo "No notes for $task_desc"
        exit 1
    }
    (
        printf "%s\n" "$task_desc"
        printf "%s\n\n\n" "$task_desc" | tr [:print:] '='
    ) >> "$location/$note_file"
    $EDITOR +4 "$location/$note_file"
}

