#!/bin/bash

targets=$(dialog --stdout --title "Target " \
--inputbox "Paste targets from https://itarmy.com.ua/check/:" 8 50)

protocol_counts=$(grep -Po "[a-z]+" <<< $targets | uniq -c)
chosen_protocol=$(dialog --title 'Choose prefered targets' --menu --stdout "Targets by protocol count:" 15 25 "$($protocol_counts | wc -l)" $protocol_counts)
chosen_protocol=$(grep "$chosen_protocol" <<< "$protocol_counts" | awk '{print $2}')

grep -Po  "$chosen_protocol:\/\/(\d+\.\d+\.\d+\.\d+:\d+)" <<< "$targets" | grep -Po  "\d+\.\d+\.\d+\.\d+:\d+" > "$SCRIPT_DIR/targets.txt"
exit