#!/bin/sh

[ -z "$2" ] && echo "Give mailbox and how many months to go back" && exit 1

set -u
set -e

mailbox="$1"
months="$2"

archived_date="$(date -d "$months months ago" +%Y-%m)"

archive_name="$(echo "$mailbox"-"$archived_date" | tr '/' '-')"

cd ~/Mail/"$mailbox"/cur

find_mails_in_box(){
	grep -lP "^Date:.*$(date -d "$months months ago" +%b\ %Y).*\d\d\d\d( \(\w{3}\))?$" *
}

store_emails_in_box(){
	find_mails_in_box | tar czf /mnt/dungeon/backups/mail-"$archive_name".tgz -T -
}

delete_emails_in_box(){
    num_found=0
	find_mails_in_box | while read -r line; do
		gio trash ~/Mail/$mailbox/cur/"$line"
        num_found=$(( num_found + 1 ))
	done
    test -z "$PS1" || echo "Deleted $num_found emails."
}


store_emails_in_box && delete_emails_in_box
