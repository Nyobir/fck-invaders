#!/bin/bash

targets=$(dialog --stdout --title "Target " \
--inputbox "Paste targets from https://itarmy.com.ua/check/:" 8 50)

protocol_counts=$(grep -Eo "[a-z]+://" <<< "$targets" | grep -Eo "[a-z]+" | uniq -c)
chosen_protocol=$(dialog --title 'Choose prefered targets' --menu --stdout "Targets by protocol count:" 15 25 "$($protocol_counts | wc -l)" $protocol_counts)
chosen_protocol=$(grep "$chosen_protocol" <<< "$protocol_counts" | awk '{print $2}')

grep -Eo "$chosen_protocol:\/\/([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+:[0-9]+)" <<< "$targets" | grep -Eo "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+:[0-9]+" > "$SCRIPT_DIR/targets.txt"
exit