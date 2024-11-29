#!/bin/sh

[ -z "$2" ] && echo "Give mailbox and how many months to go back" && exit 1

set -u
set -e

mailbox="$1"
months="$2"

archived_date="$(date -d "$months months ago" +%Y-%m)"

cd ~/Mail/"$mailbox"/cur

find_mails_in_box(){
	grep -lP "^Date:.*$(date -d "$months month ago" +%b\ %Y).*\d\d\d\d( \(\w{3}\))?$" *
}

store_emails_in_box(){
	find_mails_in_box | tar czf /mnt/dungeon/backups/mail-"$mailbox"-"$archived_date".tgz -T -
}

delete_emails_in_box(){
	find_mails_in_box | while read -r line; do
		gio trash ~/Mail/$mailbox/cur/"$line"
	done
}

store_emails_in_box && delete_emails_in_box
