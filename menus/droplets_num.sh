#!/bin/bash

MENU_OPTION=$(dialog --stdout --title "Droplets" \
--inputbox "Specify amount of droplets (Usually one account limited with 3):" 8 50 3)

echo $MENU_OPTION
exit