#!/bin/bash

SCRIPT_DIR=$(dirname "$0")
export SCRIPT_DIR

cd $SCRIPT_DIR
#git fetch

[[ -n $(git log ..origin/master) ]] && {
    echo "Found a new version of me, updating myself..."
    git checkout master
    git pull --force
    echo "Running the new version..."
    exec "$SCRIPT_DIR/botnet.sh"

    # Now exit this old instance
    exit 0
}
echo "Already the latest version."


touch -a "$SCRIPT_DIR/hosts.txt"
export DIALOGRC="$SCRIPT_DIR/.dialogrc"

while : ; do
    MENU_OPTION=$(dialog --title 'Botnet' --menu --stdout "Before the start populate your hosts.txt file!" 15 55 8  1 'Botnet attack on host' 2 'Bandwidth monitoring' 3 'Show current attacks' 4 'Stop all botnet attacks' 5 'Stop certain host/ip attack in botnet' 6 'Setup SSH hosts' 7 'Cloud providers' 8 'Exit')

    case $MENU_OPTION in

    1) #Botnet attack on host
        bash "$SCRIPT_DIR/attack.sh"
        continue
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
        output=''
        while read -r host
        do
            processes=$(ssh -o ConnectTimeout=5 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -n "root@$host" "ps -aux | grep start.py | grep -v grep | grep -vi screen" | awk '{print $13, $14}' | sed 's/^/    /')
            output+="$host\n$processes\n\n"
        done < "$SCRIPT_DIR/hosts.txt"
        printf "$output" > "$SCRIPT_DIR/output.txt"
        dialog --title "Hosts and their active attacks" --textbox "$SCRIPT_DIR/output.txt" 30 50

        continue
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

