#!/bin/bash

MENU_OPTION=$(dialog --title 'L4 attack' --menu --stdout "Choose attack type:" 30 60 18 \
   1 'TCP | TCP Flood Bypass' \
   2 'UDP | UDP Flood Bypass' \
   3 'SYN | SYN Flood' \
   4 'CPS | Open and close connections with proxy' \
   5 'CONNECTION | Open connection alive with proxy' \
   6 'VSE | Send Valve Source Engine Protocol' \
   7 'TS3 | Send Teamspeak 3 Status Ping Protocol' \
   8 'FIVEM | Send Fivem Status Ping Protocol' \
   9 'MEM | Memcached Amplification' \
   10 'NTP | NTP Amplification' \
   11 'MCBOT | Minecraft Bot Attack' \
   12 'MINECRAFT | Minecraft Status Ping Protocol' \
   13 'MCPE | Minecraft PE Status Ping Protocol' \
   14 'DNS | DNS Amplification' \
   15 'CHAR | Chargen Amplification' \
   16 'CLDAP | Cldap Amplification' \
   17 'ARD | Apple Remote Desktop Amplification' \
   18 'RDP | Remote Desktop Protocol Amplification' )

    case $MENU_OPTION in

    1)
        echo "TCP"
        ;;
    2)
        echo "UDP"
        ;;
    3)
        echo "SYN"
        ;;
    4)
        echo "CPS"
        ;;
    5)
        echo "CONNECTION"
        ;;
    6)
        echo "VSE"
        ;;
    7)
        echo "TS3"
        ;;
    8)
        echo "FIVEM"
        ;;
    9)
        echo "MEM"
        ;;
    10)
        echo "NTP"
        ;;
    11)
        echo "MCBOT"
        ;;
    12)
        echo "MINECRAFT"
        ;;
    13)
        echo "MCPE"
        ;;
    14)
        echo "DNS"
        ;;
    15)
        echo "CHAR"
        ;;
    16)
        echo "CLDAP"
        ;;
    17)
        echo "ARD"
        ;;
    18)
        echo "RDP"
        ;;

    esac
exit

