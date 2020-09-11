#!/bin/bash



sleep_dr() { sleep `printf "%d.%02d" $(( (RANDOM % 1) + 0 )) $(( RANDOM % 100 ))` ;}


boot_rpdist() {
	local conf_file=/boot/config.txt
	local cmdl_file=/boot/cmdline.txt

	printf "Backing up original /boot files..."
	if [ $dry_run == true ]; then sleep_dr
	else
		[ -f "conf_file" ] && sudo cp $conf_file $conf_file.rp-dist
		[ -f "cmdl_file" ] && sudo cp $cmdl_file $cmdl_file.rp-dist
	fi
}


sys_rpdist() {
	local bash_file=/etc/bash.bashrc
	local nano_file=/etc/nanorc
	local apt1_file=/etc/apt/sources.list
	local apt2_file=/etc/apt/sources.list.d/raspi.list

	printf "Backing up original /etc files..."
	if [ $dry_run == true ]; then sleep_dr
	else
		[ -f "bash_file" ] && sudo cp $bash_file $bash_file.rp-dist
		[ -f "nano_file" ] && sudo cp $nano_file $nano_file.rp-dist
		[ -f "apt1_file" ] && sudo cp $apt1_file $apt1_file.rp-dist
		[ -f "apt2_file" ] && sudo cp $apt2_file $apt2_file.rp-dist
	fi
}


home_rpdist() {
    local prof_file=$HOME/.profile
    local bashrc_file=$HOME/.bash_rc

    printf "Backing up original %s files..." $HOME
    if [ $dry_run == true ]; then sleep_dr
    else
        [ -f "prof_file" ] && sudo cp $proc_file $prof_file.rp-dist
        [ -f "bashrc_file" ] && sudo cp $bashrc_file $bashrc_file.rp-dist
    fi
}



dry_run=false


clear
printf "Creating rp-dist files...\n" ; echo
boot_rpdist ; echo
sys_rpdist ; echo
home_rpdist ; echo


echo ; read -n 1 -s -r -p "Completed rp-dist setup! Press any key continue..." ; echo ; echo


exit 0;
