#!/bin/bash

MENU_OPTION=$(dialog --stdout --title "Duration " \
--inputbox "Enter duration of the attack in seconds:" 8 50 3600)

echo $MENU_OPTION
exit