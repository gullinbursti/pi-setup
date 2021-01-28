#!/bin/bash


#-- install gawk first
apt update && apt install gawk -y



sudo ./setup-rpdist.sh
sudo ./setup-apt.sh
sudo ./setup-sys.sh
sudo ./setup-cfg.sh
./setup-git.sh


#-- terminate w/o error
exit 0;
