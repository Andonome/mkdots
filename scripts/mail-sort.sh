#!/bin/sh

set -u

MAILDIR=~/Mail
cd "$MAILDIR"

INBOXES="$(find . -type d -iname inbox -exec printf ' {}'/cur ';')"
SUBS="$MAILDIR/Subs/new/"
RUBBISH="$MAILDIR/Trash/new"

eval "$(cat $MAILDIR/sort.txt)" || exit 404

sanity_check(){
    [ "$(echo $src | wc -c)" -gt 5 ]
    countResults="$(cat "$INBOX"/* | grep -c "header.from=$src" )"
    if [ "$countResults" -gt 20 ]; then
        echo "This would remove $countResults emails. Aborting."
        exit 1
    fi
}

check_subs(){
    INBOX="$1"
    for src in $SUBLIST; do
        sanity_check
        grep -lP "^From: .*$src" "$INBOX"/* | while read -r mail; do
            mv "$mail" "$SUBS"
        done
    done
}

check_spam(){
    INBOX="$1"
    for src in $SPAM; do
        sanity_check
        grep -l "header.from=$src" "$INBOX"/* | while read -r mail; do
            mv "$mail" "$RUBBISH"
        done
    done
}

for INBOX in $INBOXES
do
    check_subs "$INBOX"
done

for INBOX in $INBOXES
do
    check_spam "$INBOX"
done

