#!/bin/bash

apt update;
apt install git python3 python3-pip bmon -y;

git clone https://github.com/MHProDev/MHDDoS.git;
pip3 install -r ./MHDDoS/requirements.txt;
snap install bashtop
