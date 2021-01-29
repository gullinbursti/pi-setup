#!/bin/bash


#-- install gawk first
sudo apt update && sudo apt install gawk -y



sudo ./setup-rpdist.sh
sudo ./setup-apt.sh
sudo ./setup-sys.sh
sudo ./setup-cfg.sh
./setup-git.sh


#-- terminate w/o error
exit 0;
