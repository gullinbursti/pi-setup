#!/bin/bash




bash_home() {
    local profile_file=/home/pi/.profile
    local rc_file=/home/pi/.bashrc_pi

    #-- copy bash add'l
    if [ -f "$rc_file" ]; then cp -p $rc_file $rc_file.bak ; fi
    cp -p ./home/pi/.bashrc_pi $rc_file

    #-- backup & append .profile
    if [ -f "$profile_file" ]; then cp -p $profile_file $profile_file.bak ; fi
    sudo printf "\n\n#-- appended by pi-setup\n" >> $profile_file
    cat ./home/pi/.profile >> $profile_file
}


bash_sys() {
    local rc_file=/etc/bash.bashrc

    #-- backup & append rc
    if [ -f "$rc_file" ]; then sudo cp -p $rc_file $rc_file.bak ; fi
    sudo printf "\n\n#-- appended by pi-setup\n" >> $rc_file
    sudo cat ./etc/bash.bashrc >> $rc_file
}


git_repos() {
    local repo_dir=/home/pi/.local/git

    [[ ! -d "$repo_dir" ]] && mkdir -p $repo_dir

    printf "\nCloning billw2/rpi-clone..."
    git clone https://github.com/billw2/rpi-clone.git $repo_dir/billw2
    sudo ln -s %repo_dir/billw2/rpi-clone/rpi-clone /usr/local/bin
    sudo ln -s %repo_dir/billw2/rpi-clone/rpi-clone-setup /usr/local/bin
    echo
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
    sudo printf "\n\n#-- appended by pi-setup\n" >> $rc_file
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

printf "Getting add'l software from github..."
git_repos
echo

read -n 1 -s -r -p "Completed system + home cfg setup! Press any key to reboot..." && clear
sudo reboot


exit 0;
