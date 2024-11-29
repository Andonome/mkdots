#!/bin/sh
interface=wlp2s0
sudo ip link set $interface down
sudo macchanger -a $interface
sudo ip link set wlp2s0 up
