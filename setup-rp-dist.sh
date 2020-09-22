#!/bin/bash



sleep_dr() { sleep `printf "%d.%02d" $(( (RANDOM % 1) + 0 )) $(( RANDOM % 100 ))` ;}


boot_rpdist() {
	local conf_file=/boot/config.txt
	local cmdl_file=/boot/cmdline.txt

	printf "Backing up original /boot files..."
	if [ $dry_run == true ]; then sleep_dr
	else
		[ -f "$conf_file" ] && sudo cp -p $conf_file $conf_file.rp-dist
		[ -f "$cmdl_file" ] && sudo cp -p $cmdl_file $cmdl_file.rp-dist
	fi
}


etc_rpdist() {
	local apt1_file=/etc/apt/sources.list
	local apt2_file=/etc/apt/sources.list.d/raspi.list
	local console_file=/etc/default/console-setup
	local bash_file=/etc/bash.bashrc
	local nano_file=/etc/nanorc
	local rc_file=/etc/rc.local

	printf "Backing up original /etc files..."
	if [ $dry_run == true ]; then sleep_dr
	else
		[ -f "$apt1_file" ] && sudo cp -p $apt1_file $apt1_file.rp-dist
		[ -f "$apt2_file" ] && sudo cp -p $apt2_file $apt2_file.rp-dist
		[ -f "$console_file" ] && sudo cp -p $console_file $console_file.rp-dist
		[ -f "$bash_file" ] && sudo cp -p $bash_file $bash_file.rp-dist
		[ -f "$nano_file" ] && sudo cp -p $nano_file $nano_file.rp-dist
		[ -f "$rc_file" ] && sudo cp -p $rc_file $rc_file.rp-dist
	fi
}


home_rpdist() {
    local prof_file=$HOME/.profile
    local bashrc_file=$HOME/.bash_rc

    printf "Backing up original %s files..." $HOME
    if [ $dry_run == true ]; then sleep_dr
    else
        [ -f "$prof_file" ] && sudo cp -p $prof_file $prof_file.rp-dist
        [ -f "$bashrc_file" ] && sudo cp -p $bashrc_file $bashrc_file.rp-dist
    fi
}



dry_run=false


clear
printf "Creating rp-dist files...\n" ; echo
boot_rpdist ; echo
etc_rpdist ; echo
home_rpdist ; echo


echo ; read -n 1 -s -r -p "Completed rp-dist setup! Press any key continue..." ; echo ; echo


exit 0;
