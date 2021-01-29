#!/bin/bash



sleep_dr() { sleep `printf "%d.%02d" $(( (RANDOM % 1) + 0 )) $(( RANDOM % 100 ))` ;}


boot_rpdist() {
    local conf_file=/boot/config.txt
    local cmdl_file=/boot/cmdline.txt

    printf "Backing up original /boot files..."
    if [ $dry_run == true ]; then sleep_dr
    else
        [[ -f "$conf_file" && ! -f "${conf_file}.rp-dist" ]] && sudo cp -p $conf_file $conf_file.rp-dist
        [[ -f "$cmdl_file" && ! -f "${cmdl_file}.rp-dist" ]] && sudo cp -p $cmdl_file $cmdl_file.rp-dist
    fi
}


etc_rpdist() {
    local console_file=/etc/default/console-setup
    local bash_file=/etc/bash.bashrc
    local nano_file=/etc/nanorc
    local rc_file=/etc/rc.local

    printf "Backing up original /etc files..."
    if [ $dry_run == true ]; then sleep_dr
    else
        [[ -f "$console_file" && ! -f "${console_file}.rp-dist" ]] && sudo cp $console_file $console_file.rp-dist
        [[ -f "$bash_file" && ! -f "${bash_file}.rp-dist" ]] && sudo cp $bash_file $bash_file.rp-dist
        [[ -f "$nano_file" && ! -f "${nano_file}.rp-dist" ]] && sudo cp $nano_file $nano_file.rp-dist
        [[ -f "$rc_file" && ! -f "${rc_file}.rp-dist" ]] && sudo cp $rc_file $rc_file.rp-dist
    fi
}


home_rpdist() {
    local home_dir=/home/pi
    local prof_file=$home_dir/.profile
    local bashrc_file=$home_dir/.bashrc

    printf "Backing up original %s files..." $home_dir
    if [ $dry_run == true ]; then sleep_dr
    else
        [[ -f "$prof_file" && ! -f "${prof_file}.rp-dist" ]] && sudo cp -p $prof_file $prof_file.rp-dist
        [[ -f "$bashrc_file" && ! -f "${bashrc_file}.rp-dist" ]] && sudo cp -p $bashrc_file $bashrc_file.rp-dist
    fi
}


usr_rpdist() {
    local locale_file=/usr/share/locales/i18n/locales/en_US

    printf "Backing up original /usr files..."
    if [ $dry_run == true ]; then sleep_dr
    else
        [[ -f "$locale_file" && ! -f "${locale_file}.rp-dist" ]] && sudo cp $locale_file $locale_file.rp-dist
    fi
}



dry_run=false


clear
printf "Creating rp-dist files...\n" ; echo
boot_rpdist ; echo
etc_rpdist ; echo
home_rpdist ; echo
usr_rpdist ; echo


echo ; read -n 1 -s -r -p "Completed rp-dist setup! Press any key continue..." ; echo ; echo


exit 0;
