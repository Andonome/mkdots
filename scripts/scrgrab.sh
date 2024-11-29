#!/bin/bash

sleep 1

if [[ $1 =~ ^-?[0-9]+$ ]] ; then
	ffmpeg -y -t $1 -video_size "$(xdpyinfo | grep dimensions | awk '{print $2}')" -f x11grab -i :0.0 -f pulse -ac 1 -i default ~/out.mkv

elif [[ $1 == n ]]; then
	ffmpeg -y -f pulse -i default -f x11grab -framerate 30 -video_size 1600x900 -i :0.0+0,0 -c:v libx264 -pix_fmt yuv420p -qp 0 -preset ultrafast ~/out.avi

else
	ffmpeg -y -video_size "$(xdpyinfo | grep dimensions | awk '{print $2}')" -f x11grab -i :0.0 -f pulse -ac 1 -i default ~/out.mkv

fi

if [[ $2 == t ]] ; then

	xdg-open ~/out.mkv
	rm ~/out.mkv


fi
