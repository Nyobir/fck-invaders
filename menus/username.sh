#!/bin/bash

MENU_OPTION=$(dialog --stdout --title "Username " \
--inputbox "Enter new default username:" 8 50)

echo $MENU_OPTION
exit