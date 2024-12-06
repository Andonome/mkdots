#!/bin/sh

query="${@:-+WEEK}"
alias tsk="task rc.verbose=nothing rc.gc=no"
blocking_tasks="$(tsk $query +UNBLOCKED '( status:pending or status:active )' uuids | tr ' ' '\n')"

export no_blocking_tasks=0

get_description(){
    tsk _get $1.description | tr -d [:cntrl:] | tr -d [:punct:]
}

for x in $blocking_tasks; do
    export no_blocking_tasks="$(( no_blocking_tasks + 1 ))"
    ready="$(get_description $x)"
    for d in $(tsk depends.has:$x uuids ); do
        goal="$(get_description $d)"
        printf '\n%s\n' "[ ---\n $ready \n___ ] ---> [ $goal ] {border-style: dashed;}"
        export no_blocking_tasks=$(( no_blocking_tasks + 1 ))
        if [ "$no_blocking_tasks" -lt 5 ] ; then
            for s in $(tsk depends.has:$d uuids ); do
                later="$(get_description $s)"
                printf '%s\n' "[ $goal ] ...> [ $later ] {border-style: dashed;}"
            done
        fi
    done &
done | graph-easy --boxart

