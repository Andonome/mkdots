#!/bin/sh

set -e

file_path=$HOME/pro/gemini/rpg_articles/highlights.txt

file_dir="$(dirname $file_path)"

file_name="$(basename $file_path)"

url="$(rofi -i -p 'URL' -dmenu)"

url="$(echo "${url}" | cut -d '&' -f1)"

echo "$url" | grep -q '://' || ( rofi -e "Badly formatted URL" && exit 1 )

if [ "$(grep "$url" "$file_path")" ]; then
		rofi -e "URL already exists"
		exit 1
fi

description="$(rofi -i -p 'Description' -dmenu)"
[ ! -z "$description" ]

echo "[$description]($url)" >> "$file_path"

git -C "$file_dir" add "$file_name"
git -C "$file_dir" commit -m"highlight: $description"
git -C "$file_dir" push
