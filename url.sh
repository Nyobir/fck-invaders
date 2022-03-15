#!/bin/bash

MENU_OPTION=$(dialog --stdout --title "Target " \
--inputbox "Enter target ip or host (port optional):" 8 50)

echo $MENU_OPTION
exit