#!/bin/sh

current="$(pactl get-default-sink)"
target="$(pactl list sinks | grep Name | cut -d: -f2 | grep -v $current)"
pactl set-default-sink $target
index="$(pactl list sink-inputs | head -1 | cut -d'#' -f2)"
pactl move-sink-input $index $target
