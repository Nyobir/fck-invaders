#!/bin/bash

MENU_OPTION=$(dialog --stdout --title "Proxy file " \
--inputbox "Enter proxy list filename:" 8 50 "proxy-$(date +'%d-%m').txt")

echo $MENU_OPTION
exit