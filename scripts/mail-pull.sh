#!/bin/sh

set -e

pgrep gpg-agent || exit 0

# We'll need to display messages later.
export DISPLAY=:0

# the 'mailfile' is where we keep the current number of emails

mf=/tmp/mailno

# first list mailboxes you're interested in

boxes="INBOX BIND/Inbox Pro/Inbox"

# we count the total inbox mail to use for later

countmail(){
	count=0
	for x in $boxes; do
		current_folder=$(ls "$MAIL/$x"/cur | wc -l)
		count=$(( count + current_folder ))
	done
	echo $count
}

# we'll need to create a fil to store this number if it doesn't exist

if [ ! -e "$mf" ]; then
	countmail > "$mf"
fi

oldno=$(cat $mf)

# fetch the mail with isync

mbsync -a

# finally, it's time to actually count the current mail

newno=$(countmail)

# if there's any change, store that changed number

if [ "$newno" -ne "$oldno" ]; then
	echo "$newno" > $mf
fi

# If there's more mail than before, the notification only sounds if this person is in the contact list.
# grep will grab the email address of everything in every box (even if it's old), and check if it's in the contact list in khard.
# Finally, we need 'sleep 2', so the notifications aren't too fast to see.

if [ "$newno" -gt "$oldno" ]; then
	for b in $boxes; do
		for x in $(ls $MAIL/$b/cur)
		do
			email="$(grep -Po '^From: (.+ <)?\K(\w+@\w+.\w+)' "$MAIL/$b/cur/$x")"
			if [ "$(khard "$email")" != 'Found no contacts' ];then
				notify-send "E-mail" "$email"
				sleep 2
			fi
		done
	done
fi

echo number is $newno
