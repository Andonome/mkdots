#!/bin/bash

wpa_cli list_networks | grep '\[CURRENT\]' && \
networkNo=$(wpa_cli list_networks | grep '\[CURRENT\]' | cut -f1) \
|| networkNo=$(wpa_cli list_networks | rofi -i -dmenu | cut -f1)


ssid=$(wpa_cli get_network $networkNo ssid | tail -n1 | sed 's/"//g')

psk=$(grep -A2 "$ssid" /etc/wpa_supplicant/* | grep 'psk=' | cut -d= -f2 | sed 's/"//g')

# qrencode command 
qrencode -s 6 -l H -o "/tmp/wifi.png" "WIFI:T:WPA;S:<$wifiname>;P:<$wifipass>;;"

echo "$ssid"
echo "$psk"

# display img with sxiv 
sxiv /tmp/wifi.png
