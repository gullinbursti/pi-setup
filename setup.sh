#!/bin/bash


#-- envs
#export LESS=-XRf


#-- aliases
alias apt='sudo apt'
alias ll='ls -pla'


#-- install gawk first
apt update && apt install gawk -y



./setup-rpdist.sh
./setup-apt.sh
./setup-sys.sh
./setup-cfg.sh
./setup-git.sh


#-- terminate w/o error
exit 0;
