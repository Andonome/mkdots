#!/bin/sh
targetDir="$(cat ~/.dirs | rofi -i -dmenu)"
[ -n "$targetDir" ] && urxvtc -cd "$targetDir"
