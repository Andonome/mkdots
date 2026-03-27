#!/bin/sh

filename=$(date +%s).$(hostname)

message="$(cat /dev/stdin)"

grep -qr "$message" "$MAIL/INBOX/cur/" && exit 0
grep -qr "$message" "$MAIL/INBOX/new/" && exit 0

cat << EOF > "$MAIL/INBOX/new/$filename"
FROM: <ghost@$(hostname)>
To: <malinfreeborn@posteo.net>
Subject: Alert from $(hostname)
Date: $(date --rfc-email)

"$message"
EOF
