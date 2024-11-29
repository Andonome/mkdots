#!/bin/bash

if [[ $1 == dark ]]; then
	cd ~/.dots && git checkout $HOSTNAME
	ln -sf ~/.dots/config/gtk-3.0/dark.ini ~/.config/gtk-3.0/settings.ini

else
	cd ~/.dots && git checkout $HOSTNAME-light
	ln -sf ~/.dots/config/gtk-3.0/light.ini ~/.config/gtk-3.0/settings.ini

fi

xrdb ~/.Xresources
i3-msg restart
