#!/bin/bash

MENU_OPTION=$(dialog --title 'L7 attack' --menu --stdout "Choose attack type:" 30 60 22 \
    1 'GET | GET Flood' \
   2 'POST | POST Flood' \
   3 'OVH | Bypass OVH' \
   4 'STRESS | Send HTTP Packet With High Byte' \
   5 'DYN | A New Method With Random SubDomain' \
   6 'DOWNLOADER | A New Method of Reading data slowly' \
   7 'SLOW | Slowloris Old Method of DDoS' \
   8 'HEAD | HEAD HTTP method flood' \
   9 'NULL | Null UserAgent and ...' \
   10 "COOKIE | Random Cookie PHP `if (isset($_COOKIE))`" \
   11 "PPS | Only 'GET / HTTP/1.1\r\n\r\n'" \
   12 'EVEN | GET Method with more header' \
   13 'GSB | Google Project Shield Bypass' \
   14 "DGB | DDoS Guard Bypass" \
   15 'AVB | Arvan Cloud Bypass' \
   16 'BOT | Like Google bot' \
   17 'APACHE | Apache Expliot' \
   18 "XMLRPC | WP XMLRPC expliot (add /xmlrpc.php)" \
   19 'CFB | CloudFlare Bypass' \
   20 'CFBUAM | CloudFlare Under Attack Mode Bypass' \
   21 'BYPASS | Bypass Normal AntiDDoS' \
   22 'BOMB | Bypass with codesenberg/bombardier')

    case $MENU_OPTION in

    1)
        echo "GET"
        ;;
    2)
        echo "POST"
        ;;
    3)
        echo "OVH"
        ;;
    4)
        echo "STRESS"
        ;;
    5)
        echo "DYN"
        ;;
    6)
        echo "DOWNLOADER"
        ;;
    7)
        echo "SLOW"
        ;;
    8)
        echo "HEAD"
        ;;
    9)
        echo "NULL"
        ;;
    10)
        echo "COOKIE"
        ;;
    11)
        echo "PPS"
        ;;
    12)
        echo "EVEN"
        ;;
    13)
        echo "GSB"
        ;;
    14)
        echo "DGB"
        ;;
    15)
        echo "AVB"
        ;;
    16)
        echo "BOT"
        ;;
    17)
        echo "APACHE"
        ;;
    18)
        echo "XMLRPC"
        ;;
    19)
        echo "CFB"
        ;;
    20)
        echo "CFBUAM"
        ;;
    21)
        echo "BYPASS"
        ;;
    22)
        echo "BOMB"
        ;;

    esac
exit

