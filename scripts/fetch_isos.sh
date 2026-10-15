#!/bin/sh
# Quickly download ISO images with transmission.

set -e

[ -n "$download_dir" ] || download_dir="$(pwd)"

## Arch

iso_address="https://archlinux.org/releng/releases/"

arch_iso_page="$(wget --quiet -O- "$iso_address")"
magnet_link="$(echo "$arch_iso_page" | grep "$(date +%Y.%m.01-x86_64)" | cut -d '"' -f2 | cut -d'&' -f1)"

command -v transmission-remote > /dev/null && \
    systemctl status transmission-daemon || sudo systemctl start transmission-daemon && \
    transmission-remote -a "$magnet_link" --download-dir "$download_dir" ||\
    echo "$magnet_link"

## Debian

mkdir -p Debian

url='https://cdimage.debian.org/debian-cd/current/amd64/bt-cd/'
page="$(wget --quiet -O- "$url")"

torrent_suffix="$(echo "$page" | tr '<' '\n' | grep -m1 -Po "debian-.*netinst.iso.torrent")"

wget -O "$download_dir"/deb.torrent "$url$torrent_suffix"
transmission-remote -a "$download_dir"/deb.torrent --download-dir "$download_dir"/Debian

## Kali

page="$(wget --quiet -O- 'https://www.kali.org/get-kali/#kali-live')"
torrent_link="$(echo "$page"  | tac | grep -oP "https://.*live-amd64.iso.torrent" -m 1)"

wget "$torrent_link" -O "$download_dir"/kali.torrent
transmission-remote -a "$download_dir"/kali.torrent --download-dir "$download_dir"/Debian
rm "$download_dir"/kali.torrent 

#https://repo-default.voidlinux.org/live/current/void-live-x86_64-20250202-base.iso
