#!/bin/bash

SSH_HOSTS=$(doctl compute droplet list --format=PublicIPv4 --no-header)
PARAMETHERS="$@"

for HOST in $SSH_HOSTS; do
    bash "$CURRENT_DIR/runoverssh" root "pkill -f '$PARAMETHERS'" "$HOST"
done

