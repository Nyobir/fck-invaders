#!/usr/bin/bash

while read -r host; do
  ssh -o ConnectTimeout=5 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -n "$USER@$host" "$@" &
done < "$SCRIPT_DIR/hosts.txt"
wait