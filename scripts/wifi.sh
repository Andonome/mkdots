#!/bin/bash

wpa_cli scan

rofi -e 'Scanning'

ssid="$(wpa_cli scan_results | awk '{$1=$2=$3=$4=""; print $0}' | tail -n +3 | sort | uniq | while read -r line; do echo $line ; done | rofi -i -dmenu)"

[ -z "$ssid" ] && exit 0

# check for duplicates

if [ "$(wpa_cli list_networks | sort -hr | awk '{print $2}' FS='\t' | grep -c "$ssid" )" -gt 0 ]; then
	rofi -e 'Updating network password'
	netno=$(wpa_cli list_networks | grep "$ssid" | head -n1 | awk '{print $1}' FS='\t')
fi

# remove networks by typing 'remove' instead of selecting a network
if [ "$ssid" = "remove" ]; then
	badNetwork="$(wpa_cli list_networks | sort -hr | rofi -i -dmenu | awk '{print $1}')"
	wpa_cli remove_network "$badNetwork"
	wpa_cli save_config
	exit 0
fi

password="$(rofi -dmenu)"

[ -z "$password" ] && exit 0

[ -z "$netno" ] && netno=$(wpa_cli add_network | tail -n1)

wpa_cli set_network $netno ssid \""$ssid"\"
if [ "$password" = "NONE" ]; then
	wpa_cli set_network $netno key_mgmt NONE
else
	wpa_cli set_network $netno psk \""$password"\"
fi
wpa_cli enable_network $netno
wpa_cli save_config
