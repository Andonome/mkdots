#!/bin/sh

set -u
set -e

cd ~/Mail

mailbox="${1:-Trash}"
no_weeks="${2:-12}"

archive_name="$mailbox-$(date -d "$no_weeks weeks ago" +%Y-%m-%d)"
backup_location=/mnt/dungeon/backups/mail

old="$(date -d "$no_weeks weeks ago" +%s)"

find_old_emails(){
    for email in $mailbox/cur/*; do
        test "$(date -d "$(grep -im1 '^date:' "$email" | cut -d: -f2)" +%s)" -gt "$old" || \
            echo "$email"
    done

}

email_list="$(find_old_emails)"

test ! -n "$email_list" && exit 0

tar -czf "$backup_location"/"$archive_name".tgz $email_list

gio trash $email_list
