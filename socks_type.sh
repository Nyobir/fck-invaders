#!/bin/bash

MENU_OPTION=$(dialog --title 'Socks type' --menu --stdout "Choose Socks type:" 12 30 5 \
    0 'All Proxy' \
   1 'HTTP' \
   4 'SOCKS4' \
   5 'SOCKS5' \
   6 'RANDOM')

echo $MENU_OPTION
exit