#!/bin/sh

TMP=/tmp/task

remote=nimbus

remove_task_sync_mount(){
    fusermount3 -u "$TMP"
    rmdir "$TMP"
}

trap remove_task_sync_mount 1

set -e

[ -d "$TMP" ] || mkdir -m700 "$TMP"

sshfs "$remote":.local/share/task "$TMP"
test -e "$TMP"/taskchampion-local-sync-server.sqlite3 && task rc.gc:off rc.hooks:off sync && sync || {
    echo Failed to mount tasks
    remove_task_sync_mount
    command -v logger >/dev/null && logger "Failed to mount tasks"
    exit 4
}

remove_task_sync_mount
