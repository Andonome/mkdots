#!/bin/bash
# clip an image, and put it into the clipboard
name="clip_$(date +%s).png"
scrot -zfs /tmp/"$name"
xclip -selection clipboard -t image/png < /tmp/"$name"
sleep 30m && rm /tmp/"$name"
