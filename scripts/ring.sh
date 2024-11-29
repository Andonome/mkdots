#!/bin/sh
[ -e /tmp/ring_done ] && exit 0
play /usr/share/backgrounds/ring.mp3
touch /tmp/ring_done
sleep 10m && rm /tmp/ring_done
