#!/bin/bash



sleep_dr() { sleep `printf "%d.%02d" $(( (RANDOM % 1) + 0 )) $(( RANDOM % 100 ))` ;}


apt_src() {
    local deb_file=/etc/apt/sources.list.d/deb-src.list
#    local deb_file=/etc/apt/sources.list
#    local rpi_file=/etc/apt/sources.list.d/raspi.list

    printf "Backing up prev src lists..."
    if [ $dry_run == true ]; then sleep_dr
    else
        [ -f "$deb_file" ] && sudo cp $deb_file $deb_file.bak
#        [ -f "$rpi_file" ] && sudo cp $rpi_file $rpi_file.bak
    fi
    echo

    printf "Adding deb-src.list to sources.list.d..."
    sudo printf "\n\n#-- appended by pi-setup\n" >> $deb_file
    sudo cat etc/apt/sources.list.d/deb-src.list > $deb_file

#    printf "Uncommenting deb-src..."
#    if [ $dry_run == true ]; then sleep_dr
#    else
#        sudo sed -Ei 's/# Uncomment/\n# Uncomment/g' $deb_file
#        sudo sed -Ei 's/#deb-src/deb-src/g' $deb_file
#        sudo sed -Ei 's/# Uncomment/\n# Uncomment/g' $rpi_file
#        sudo sed -Ei 's/#deb-src/deb-src/g' $rpi_file
#    fi
    echo ; echo
}


apt_upg() {
    if [ $dry_run == true ]; then sleep_dr ; printf "Upgrading installed pkgs...\n" ; sleep_dr

    else
        sudo apt update ; echo
        printf "Upgrading installed pkgs...\n"
#        sudo apt upgrade -y
    fi
    echo
}


apt_inst() {
    local pkgs="bc exfat-utils gawk git hfsutils jq pv source-highlight sysbench tmux wget"
#    local pkgs_ins=$(apt list 2> /dev/null | grep installed)

#    echo "Org List:\n[=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=]\n" ; echo ${pkgs} ; echo
#    echo $pkgs | awk 'BEGIN {RS=" "} ; {print length($0),$0}' | gawk 'BEGIN {max=0 ; tot=0} ; {if($1 > max) max=$1 ; arr[tot]=$2 ; tot=tot+1} ; END {for(i=0; i<tot-1; i++) printf "[%*s]\n",(max),arr[i]}' | tr ' ' '.' | sed -E 's/([a-z\-]+)/ \1 /g' ; echo

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
#apt_src ; echo

printf "Updating & upgrading...\n"
#apt_upg ; echo

printf "Prepping preliminary packages for install...\n"
apt_inst ; echo

printf "Auto removing + auto clean up...\n"
#apt_cleanup ; echo


read -n 1 -s -r -p "Completed apt setup + updates! Press any key to reboot..." && clear
sudo reboot


exit 0;






#!/bin/bash




bash_home() {
    local profile_file=/home/pi/.profile
    local rc_file=/home/pi/.bashrc_pi

    #-- copy bash add'l
    if [ -f "$rc_file" ]; then cp -p $rc_file $rc_file.bak ; fi
    cp -p ./home/pi/.bashrc_pi $rc_file

    #-- backup & append .profile
    if [ -f "$profile_file" ]; then cp -p $profile_file $profile_file.bak ; fi
    sudo printf "\n\n#-- appended by pi-setup\n" >> $rc_file
    cat ./home/pi/.profile >> $profile_file
}


bash_sys() {
    local rc_file=/etc/bash.bashrc

    #-- backup & append rc
    if [ -f "$rc_file" ]; then sudo cp -p $rc_file $rc_file.bak ; fi
    sudo printf "\n\n#-- appended by pi-setup\n" >> $rc_file
    sudo cat ./etc/bash.bashrc >> $rc_file
}


home_dir() {
    local bin_dir=/home/pi/.local/bin

    #-- create a ~/.local/bin & apply ownership
    [[ ! -d "$bin_dir" ]] && mkdir -p $bin_dir
    chown pi:pi $bin_dir
}


nano_home() {
    local rc_file=/home/pi/.nanorc
    local rc_dir=/home/pi/.nano

    #-- backup & replace .nanorc
    if [ -f "$rc_file" ]; then cp -p $rc_file $rc_file.bak ; fi
    cp -p ./home/pi/.nanorc $rc_file

    #-- copy syntax files
    if [ ! -d "$rc_dir" ]; then mkdir -p $rc_dir ; fi
    sudo chown -R pi:pi $rc_dir
    cp -p ./home/pi/.nano/* $rc_dir/
}


nano_sys() {
    local bkup_dir=/usr/local/var/nano/backups
    local rc_file=/etc/nanorc

    #-- create nano backups dir
    if [ ! -d "$bkup_dir" ]; then sudo mkdir -p $bkup_dir ; fi
    sudo chown -R root:adm $bkup_dir
    sudo chmod -R 775 $bkup_dir

    #-- backup & append rc
    if [ -f "$rc_file" ]; then sudo cp -p $rc_file $rc_file.bak ; fi
    sudo cat ./etc/nanorc >> $rc_file
}


tmux() {
    local conf_file=/home/pi/.tmux.conf

    if [ -f "$conf_file" ]; then cp -p $conf_file $conf_file.bak ; fi
    cp -p ./home/pi/.tmux.conf $conf_file
}



clear
printf "Modifying system bash & nano /etc files..."
bash_sys
nano_sys
echo

printf "Modifying %s files..." "/home/pi"
home_dir
bash_home
nano_home
tmux
echo



read -n 1 -s -r -p "Completed system + home cfg setup! Press any key to reboot..." && clear
sudo reboot


exit 0;
