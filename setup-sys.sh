#!/bin/bash




boot_config() {
    local conf_file=/boot/config.txt
    local cmd_file=/boot/cmd.txt

    [ -f "$conf_file" ] && sudo cp $conf_file $conf_file.bak
    [ -f "$cmd_file" ] && sudo cp $conf_file $cmd_file.bak

    sudo cp ./boot/config.txt $conf_file
    sudo cp /boot/cmdline.txt $cmd_file
}


group_mod() {
    local add_grps=( wheel )
#    sudo usermod --groups "$grps_add" --append pi
#    sudo usermod --groups staff --append pi
}


kb_config() {
    local rc_file=/etc/rc.local
    [ -f "$rc_file" ] && sudo cp $rc_file $rc_file.bak

    sudo sed -i 's/exit 0//' $rc_file
    sudo printf "\n\n#-- appended by pi-setup\n" >> $rc_file
    sudo cat ./etc/rc.local >> $rc_file
}


mnt_stubs() {
	local mnt_root=/media/pi

	[ ! -d "$mnt_root" ] && sudo mkdir -p $mnt_root
	for i in `seq 0 7`; do
		[ ! -d "$mnt_root/usb$i" ] && sudo mkdir -p ${mnt_root}/usb${i}
	done

	#-- apply ownership + access
	sudo chown -R pi:adm $mnt_root
	sudo chmod -R 775 $mnt_root

	#-- make symlink to 1st usb
	if [ ! -s "$mnt_root/usb" ]; then
		cd $mnt_root
		sudo ln -s ./usb0 usb
	fi

	[ ! -s /home/pi/usb ] && ln -s $mnt_root/usb /home/pi/usb
}


change_locale() {
    local ampm_fmt="%H:%M:%S"
    local date_fmt="%a %b %e %r %z %Y"
    local locale_file=/usr/share/i18n/locales/en_US

    #[ ! -z $(grep ampm $locale_file) ] && sudo sed -Ei 's/# (en_US.*)/\1/g' $locale_file
    #[ ! -z $(grep date $locale_file) ] && sudo sed -Ei 's/# (en_US.*)/\1/g' $locale_file

    sudo dkpg-reconfigure locale
    printf "\nUTC time is: %s\n" `date -u`
}




clear
printf "Replacing boot configs..."
boot_config
echo

printf "Creating group 'wheel' & adding user 'pi' to it + 'staff' groups..."
group_mod
echo

printf "Enabling NumLock on boot..."
kb_config
echo

printf "Creating stub dirs for USB mounting at %s..." "/media/pi"
mnt_stubs
echo

#printf "Changing date/time locale formatting..."
#change_locale
echo

read -n 1 -s -r -p "Completed filesystem changes! Press any key to reboot...\n" && clear
sudo reboot



exit 0;
