#!/bin/bash

#Stopping all attacks
killall screen

# Choosing update method based on logged user (root/non-root)
if [ "$(id -u)" -eq 0 ]; then
  apt-get update;
  apt-get install git python3 python3-pip -y;
  snap install bashtop;
else
  sudo apt-get update;
  sudo apt-get install git python3 python3-pip -y;
  sudo snap install bashtop;
fi

# Updating/Installing DDoS utility
if [[ -d ./MHDDoS ]]; then
    cd MHDDoS
    git checkout main
    git pull --force
else
    git clone https://github.com/Nyobir/MHDDoS.git;
fi
# Clearing proxies list
rm -rf ./MHDDoS/files/proxies/*
# Updating dependencies
pip3 install -r ./MHDDoS/requirements.txt;

exit 0