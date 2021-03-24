#!/bin/bash



sleep_dr() { sleep `printf "%d.%02d" $(( (RANDOM % 1) + 0 )) $(( RANDOM % 100 ))` ;}


apt_src() {
    local deb_file=/etc/apt/sources.list.d/deb-src.list

    printf "Backing up prev src lists..."
    if [ $dry_run == true ]; then sleep_dr
    else
        [ -f "$deb_file" ] && sudo cp $deb_file $deb_file.bak
    fi
    echo

    printf "Adding deb-src.list to sources.list.d..."
    sudo printf "\n\n#-- appended by pi-setup\n" >> $deb_file
    sudo cat etc/apt/sources.list.d/deb-src.list >> $deb_file
    echo ; echo
}


apt_upg() {
    if [ $dry_run == true ]; then sleep_dr ; printf "Upgrading installed pkgs...\n" ; sleep_dr

    else
        sudo apt update ; echo
        printf "Upgrading installed pkgs...\n"
        sudo apt upgrade -y
    fi
    echo
}


apt_inst() {
    local pkgs="bc exfat-utils gawk git hfsutils jq pv source-highlight sysbench tmux wget"

    if [ $dry_run == true ]; then sleep_dr
    else
        sudo apt install -y $pkgs
    fi
    echo
}


apt_cleanup() {
    if [ $dry_run == true ]; then sleep_dr
    else
        sudo apt autoremove -y
        sudo apt autoclean -y
    fi
    echo
}



dry_run=false


clear
printf "Adding deb-src packages...\n"
apt_src ; echo

printf "Updating & upgrading...\n"
apt_upg ; echo

printf "Prepping preliminary packages for install...\n"
apt_inst ; echo

printf "Auto removing + auto clean up...\n"
apt_cleanup ; echo


read -n 1 -s -r -p "Completed apt setup + updates! Press any key to reboot..." && clear
sudo reboot


exit 0;
