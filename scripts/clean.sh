#!/bin/sh
# Routine maintenance, such as updates

# The log file logs errors

[ -f "/tmp/CLEAN-*" ] && rm "/tmp/CLEAN-*" 

[ -z "$logfile" ] && logfile=$(mktemp -t CLEAN-XXX)

[ -n "$ARC" ] && mkdir -p ~/arc/$ARC

# The 'say' function displays things

if [ $(command -v figlet) ]; then
	if [ $(command -v lolcat) ]; then
		say() {
			figlet "$1" | lolcat
		} || \
		say() {
			figlet "$1"
		}
	fi
	else
	say() {
		echo "$1"
		sleep 1
	}
fi

makeHomeIndex(){
    find $HOME -maxdepth 4 -type d,l -not -path '*/\.*' > "$HOME"/.cache/index
}

if [ $(command -v fastfetch) ]; then
	fastfetch
fi

sleep 3

. /etc/os-release || (
	say "Cannot find operating system. Aborting." && exit 1
)

[ -f /tmp/last-clean ] && \
	say "$(cat /tmp/last-clean)"

date +%F > /tmp/last-clean

cd ~/.dots
git fetch
git merge origin/master -m'automatic dot update'
git push
make
cd ~

update_as_so(){
	[ $(command -v $1) ] && (
		$1 $2 || say "Problem updating with $1" | tee -a "$logfile"
	)
}

update_as_sudo(){
	[ $(command -v $1) ] && (
		sudo $1 $2 || say "Problem updating with $1" | tee -a "$logfile"
	)
}

stop_unison(){
	[ $(command -v sv) ] && SERVICE_COMMAND="sv"
	[ $(command -v systemctl) ] && SERVICE_COMMAND="systemctl"
	sudo $SERVICE_COMMAND status unison >/dev/null 2>/dev/null && \
			sudo $SERVICE_COMMAND stop unison
	for x in $(pgrep unison); do
			kill "$x"
	done
	find "$HOME" -name "*.unison.tmp" -exec rm -rf '{}' ';'
	sudo $SERVICE_COMMAND start unison
}

start_unison(){
		sudo $SERVICE_COMMAND start unison
}

sunday_big_clean(){
	git -C ~/.dots gc
	update_as_so yay "-Sc --noconfirm"
	update_as_sudo reflector  "--latest 5 --country Serbia --save /etc/pacman.d/mirrorlist"
	update_as_sudo pacman "-Sc --noconfirm"
	command -v pacman >/dev/null && update_as_sudo pacman "-Rsn $(pacman -Qdtq)"
	update_as_sudo xbps-remove "-oOy"
	update_as_so vkpurge list
	update_as_sudo pkgfile "-u"
	update_as_sudo /opt/texlive/"$(date +%Y)"/bin/x86_64-linux/tlmgr "update --all"
	stop_unison
	start_unison
}

sudo find /etc/ -name "*.pacnew" >> "$logfile"

[ "$(date +%u)" = 7 ] && \
	sunday_big_clean

update_as_sudo apt-get update
update_as_sudo apt-get dist-upgrade

update_as_sudo xbps-install "-Syu"


update_as_so yay "-Syu"

update_as_so flatpak update

update_as_so pihole '-g'

update_as_so bugwarrior-pull ""

update_as_so dysk ""
