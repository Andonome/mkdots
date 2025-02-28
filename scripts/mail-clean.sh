#!/bin/sh

set -u
set -e

cd ~/Mail

mailbox="${1:-Trash}"
no_weeks="${2:-12}"

old="$(date -d "$no_weeks weeks ago" +%s)"

find_old_emails(){
    for email in $mailbox/cur/*; do
        test "$(date -d "$(grep -im1 '^date:' "$email" | cut -d: -f2)" +%s)" -gt "$old" || \
            echo "$email"
    done

}

email_list="$(find_old_emails)"

test ! -n "$email_list" && exit 0

gio trash $email_list
