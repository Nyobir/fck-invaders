#!/bin/bash

if [ "$(id -u)" -eq 0 ]; then
  apt-get update;
  apt-get install git python3 python3-pip -y;
  snap install bashtop;
else
  sudo apt-get update;
  sudo apt-get install git python3 python3-pip -y;
  sudo snap install bashtop;
fi

rm -rf MHDDoS;
git clone https://github.com/Nyobir/MHDDoS.git;
pip3 install -r ./MHDDoS/requirements.txt;

exit 0