#!/usr/bin/bash

if dialog --title "Setup SSH hosts" --stdout --yesno "Following command will install MHDDoS tool to your SSH hosts\nIn case of update all attacks will be stopped\n                    Do you want to proceed?" 7 65; then
  while read -r host; do
    ssh -o ConnectTimeout=5 -o StrictHostKeyChecking=no -o  UserKnownHostsFile=/dev/null $USER@${host} "bash  -s" < "$SCRIPT_DIR/attacker-setup.sh" &
  done < "$SCRIPT_DIR/hosts.txt"
  wait
  dialog --title "Ok" --msgbox "Hosts is ready to use!\nRoast this fuckers!" 6 50
fi