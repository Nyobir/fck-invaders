#!/bin/bash

apt update;
apt install git python3 python3-pip -y;
rm -rf MHDDoS;
git clone https://github.com/Nyobir/MHDDoS.git;
pip3 install -r ./MHDDoS/requirements.txt;
snap install bashtop
