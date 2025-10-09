#!/bin/sh

TMP=/tmp/task

remote=splint.rs

remove_task_sync_mount(){
    fusermount3 -u "$TMP"
    rmdir "$TMP"
}

mount_task_server(){
    df -t fuse.sshfs 2>/dev/null | grep -q "$TMP" || \
    sshfs "$remote":.local/share/task "$TMP"
}

sync_tasks(){
    test -e "$TMP"/taskchampion-local-sync-server.sqlite3 && task rc.gc:off rc.hooks:off sync && sync 
}

trap remove_task_sync_mount 1

set -e

[ -d "$TMP" ] || mkdir -m700 "$TMP"

mount_task_server

sync_tasks

remove_task_sync_mount
