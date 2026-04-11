#!/bin/sh

set -e

test -n "$SUDO_USER" && wiDB=$SUDO_HOME/rec/wifi.rec || wiDB=~/rec/wifi.rec

check_db_exists(){
    test -f "$wiDB" || echo '%rec: wifi' >> "$wiDB"
}

check_wifi_exists(){
    count_name="$(recsel -t wifi "$wiDB" -e "name = \"${1}\"" -c)"
    test "$count_name" -gt "0"
}

insert_wifi(){
    recins -t wifi "$wiDB" -f name -v "${name}"
}

insert_password(){
    password="$(grep -Po 'Passphrase=\K.*' "$f")"
    recins -t wifi "$wiDB" -f name -v "${1}" -f password -v "${password}"
}

#####

check_db_exists

for f in /var/lib/iwd/*.open; do
    name="$(basename "$f" .open )"
    check_wifi_exists "$name" || insert_wifi "$name"
done

for f in /var/lib/iwd/*.psk; do
    name="$(basename "$f" .psk )"
    check_wifi_exists "$name" || insert_password "$name"
done

test -z "$SUDO_USER" || chown "$SUDO_USER:$SUDO_USER" "$wiDB"

