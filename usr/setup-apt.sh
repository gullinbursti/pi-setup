#!/bin/bash


pkgs="bc exfat-utils git hfsutils jq pv source-highlight sysbench tmux wget"


clear
printf "Updating & upgrading apt...\n"
sudo apt update
sudo apt upgrade -y

printf "\nInstalling packages: %s...\n" "$pkgs"
sudo apt install -y $pkgs

printf "\nAuto removing & cleaning...\n"
sudo apt autoremove -y
sudo apt autoclean -y

printf "\nSetup complete!\n"


exit 0;
