#!/bin/sh

db=torrents.rec

[ -e "$db" ] || echo "
%rec: Torrent
%key: Name
%sort: Type
%mandatory: Name
%mandatory: Hash
%type: Hash,Trackers int
" > "$db"

count_trackers () 
{ 
    h="$(recsel -t Torrent torrents.rec -n $1 -P Hash | sed 's/0x//')";
    n="$(transmission-remote -t $h -it | grep Tracker -c)";
    recset -t Torrent "$db" -e "Hash = '0x${h}'" -f Trackers -S "$n"
}

number_of_torrents="$(recsel -t Torrent "$db" -c)"

count_all_trackers(){
    total="$(( number_of_torrents - 1 ))"
    for i in $(seq 0 $total); do
        count_trackers "$i"
    done
}

seeker=${FUZZY:-sk}

chosen_torrent="$(transmission-remote -l | sk | awk '{print $1}' )"

info="$(transmission-remote -t "$chosen_torrent" -i)"

name="$(echo "$info" |\
    sed -n 's/[_.]/ /g ; /Name: /s/^  Name: //p '
    )"

size="$(echo "$info" |\
    awk '/Total size:/ {print $3, $4}' \
    )"

hash="$(echo "$info" |\
    sed -n 's/  Hash: /0x/p'
    )"

category="$(echo "$info" |\
    sed -n 's/  Location: //p'
    )"

category="$(basename $category)"

place_choice(){
    echo ""
    echo "Name: $name"
    echo "Hash: $hash"
    echo "Type: $category"
    echo "Size: $size"
}

count_hashes(){
    recsel "$db" --expression "Hash = '${hash}'" -c
}

[ "$(count_hashes "$chosen_torrent")" -gt "0" ] && echo Already got $name || \
    place_choice "$chosen_torrent" >> "$db"

count_all_trackers
