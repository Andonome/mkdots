#!/bin/sh

set -e

db=~/rec/torrents.rec

check_db(){
    [ -f "$db" ] || sed 's/^ *//' > "$db" << EOF
    %rec: Torrent
    %key: Hash
    %sort: Type
    %mandatory: Name
    %mandatory: Hash
    %type: Hash int
    %type: Ratio real
    %type: Name,Type line
EOF
}

format_torrent_info(){
    {
        echo 'Name,Hash,Size,Ratio'
        transmission-remote -t $1 -j -i \
        | jq -r '.result.torrents.[] | [.name, "0x" + .hash_string, .total_size, .upload_ratio] | @csv'
    } | csv2rec
}

insert_torrent(){
    torrent_info="$(format_torrent_info "$1")"
    printf '\n%s\n' "$torrent_info" | recfix \
    && printf '\n%s\n' "$torrent_info" | tee -a "$db" | recsel -p 'Name:Added'
}

##############

check_db

fuzzy="$(command -v fzy fzf sk | tail -1)"

name="$(transmission-remote -j --list | jq -r '.result.torrents.[].name' | $fuzzy )"

id="$(transmission-remote -j --list | jq --arg name "$name" '.result.torrents.[] | select(.name == $name) | .id')"

hash="0x$(transmission-remote -t $id -j -i | jq -r '.result.torrents.[].hash_string')"

torrent_count="$(recsel "$db" -t Torrent -e "Hash = '${hash}'" -c )"

test $torrent_count -gt 0 && echo "We already got one" || insert_torrent "$id"

recfix --sort "$db"
