#!/bin/bash

MENU_OPTION=$(dialog --stdout --title "Threads " \
--inputbox "Enter threads number (not more than 1000 recommended):" 8 50 1000)

echo $MENU_OPTION
exit