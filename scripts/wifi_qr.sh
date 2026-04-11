#!/bin/sh

wiDB=~/rec/wifi.rec

set -e

ssid=$(iw dev | grep -Po '\s+ssid \K.*')

pass="$(recsel "$wiDB" -t wifi -e "name = \"${ssid}\"" -CP password)"

test "${#pass}" -gt 3
qrencode -s 6 -l H -o "/tmp/wifi.png" "WIFI:T:WPA;S:<$ssid>;P:<$pass>;;"

echo "$ssid"
echo "$psk"

xdg-open /tmp/wifi.png && rm /tmp/wifi.png
