#!/bin/bash

set -e
set -u

magick /usr/share/backgrounds/$1/"$(ls /usr/share/backgrounds/$1 | sort -R | tail -n 1)" -crop 100%x50% /usr/share/backgrounds/out.jpg

cd ~/.dots

if [[ $1 == dark ]]; then
	git checkout $HOSTNAME
else
	git checkout $HOSTNAME-light
fi

make

app_list='signal-desktop autotiling'
for app in $app_list ; do
    (
        pgrep $app && \
        pkill $app && \
        $app 2>&1 >/dev/null & disown
    )
done

! pgrep qutebrowser || qutebrowser :config-source
! pgrep aerc || aerc :reload -C
! pgrep cmus || cmus-remote --server /tmp/cmus -C 'source ~/.config/cmus/rc'

swaymsg reload

