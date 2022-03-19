#!/usr/bin/bash

if dialog --title "Setup SSH hosts" --stdout --yesno "Following command will install MHDDoS tool to your SSH hosts\n                    Do you want to proceed?" 7 65; then
    bash "$SCRIPT_DIR/runoverssh" --script "$SCRIPT_DIR/attacker-setup.sh" --hostsfile "$SCRIPT_DIR/hosts.txt" root
fi