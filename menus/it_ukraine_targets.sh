#!/bin/bash

targets=$(dialog --stdout --title "Target " \
--inputbox "Paste targets from https://itarmy.com.ua/check/:" 8 50)

grep -Po  "tcp:\/\/(\d+\.\d+\.\d+\.\d+:\d+)" <<< "$targets" | grep -Po  "\d+\.\d+\.\d+\.\d+:\d+" > "$SCRIPT_DIR/targets.txt"
exit