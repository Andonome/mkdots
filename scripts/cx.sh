#!/bin/bash

[ -z "$1" ] && {
    echo "Markdown code extractor."
    echo "Usage: $0 \$file.md"
    exit 0
}

display=false

process_code(){
    case ${type} in
        gra)
             echo "${line}" | graph-easy --boxart
        ;;
        *)
            echo "${line}" 
        ;;
    esac
}

while read -r line; do
    if [ "${line:0:3}" = '```' ] && [ ${display} = "false" ]; then
        type="${line:3:3}"
        echo "# $type"
        display=true && continue
    elif [ "${line}" = '```' ]; then
        display=false
    fi
    if [ "${display}" = "true" ]; then
        process_code
    fi
done < "$1"
