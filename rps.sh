#!/bin/bash

MENU_OPTION=$(dialog --stdout --title "Requests per second " \
--inputbox "Enter RPS number (not more than 100 recomended):" 8 50 100)

echo $MENU_OPTION
exit