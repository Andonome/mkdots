#!/bin/sh

set -e
set -u

n=0

out=local.rc

JSON=$(mktemp)

holiday="null"

workdir="$(mktemp -d)"

####################

fetch_holidays(){
    place="$(echo $LANG | cut -d. -f1 | tr '_' '-')"
    year="$(date -d '3 months' +%Y)"
    curl -s https://holidata.net/$place/$year.json > "$JSON"
}

get_holiday(){
    cat "$JSON" | jq --slurp .[$n]
}

check_holiday_exists(){
    if [ "$holiday" = "null" ]; then
        echo "holiday $n does not exist"
        exit 0
    fi
}

set_holiday_property(){
    echo "$holiday" | jq --slurp .[].$1
}

set_date_and_description(){
    date="$(set_holiday_property date | tr -d '-' | tr -d '"')"
    description="$(set_holiday_property description)"
}

output_holiday_in_taskwarrior_format(){
    if grep -q "$date" "$out"; then
        return 0
    else
        echo "holiday.$date.name=$description" >> "$out"
        echo "holiday.$date.date=$date" >> "$out"
    fi
}

####################

touch "$out"

for n in $(seq 1 7); do
    fetch_holidays

    holiday="$(get_holiday)"

    check_holiday_exists

    set_date_and_description

    output_holiday_in_taskwarrior_format

done

