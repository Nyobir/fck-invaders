#!/bin/bash

MENU_OPTION=$(dialog --title 'Digital Ocean *doctl required for this menu*' --menu --stdout "Choose option:" 15 55 2 1 'Create droplets' 2 'Delete all droplets' 3 'Copy droplets ips to hosts.txt' 4 'Back')
case $MENU_OPTION in

  1)
      requested_num=$(bash "${SCRIPT_DIR}/menus/droplets_num.sh")
      KEYS=$(doctl compute ssh-key list --format=ID --no-header | tr '\n' ',')

      current_droplet_num=$(doctl compute droplet list --no-header | grep -c active)
      total_num=$((current_droplet_num + requested_num))
      for ((c=1; c<=requested_num; c++))
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
             --region "$REGION" \
             --ssh-keys "${KEYS}" \
             --enable-monitoring \
             "fck-invaders-${REGION}-${HASH}"
      done
      dialog --title "Ok" --msgbox "Droplets was successfully requested!\nWait for them to be created..." 6 50
      while [ $(doctl compute droplet list --no-header | grep -c active) -ne $total_num ]; do
          echo "Waiting for droplets to be created..."
          sleep 5
      done
      echo "Droplets was successfully requested! Copying them to hosts.txt"
      doctl compute droplet list --format=PublicIPv4 --no-header > "$SCRIPT_DIR/hosts.txt"
      echo "Ip addresses was successfully rewritten in hosts.txt"
      echo "Starting hosts setup..."
      bash "$SCRIPT_DIR/setup_hosts.sh"
      dialog --title "Ok" --msgbox "Droplets is ready to use!\nRoast this fuckers!" 6 50
      ;;

  2)
      requested_num=$(bash "${SCRIPT_DIR}/menus/droplets_num.sh")
      # Load list of droplets ID
      DROPLETS=$(doctl compute droplet list --format ID,Name --no-header | awk '{print $1}')
      clear
      echo "$DROPLETS"
      # Deleting all found
      doctl compute droplet delete $DROPLETS -f
      dialog --title "Ok" --msgbox "Droplets was successfully deleted!" 6 50

      ;;

  3)
      doctl compute droplet list --format=PublicIPv4 --no-header >> "$SCRIPT_DIR/hosts.txt"
      dialog --title "Ok" --msgbox "Ip addresses was successfully appended to hosts.txt" 6 50
      ;;

  4)
      exit
      ;;
esac
