#!/bin/bash




boot_config() {
	local conf_file=/boot/config.txt
	local cmd_file=/boot/cmd.txt

	[ -f "$conf_file" ] && sudo cp $conf_file $conf_file.bak
	[ -f "$cmd_file" ] && sudo cp $conf_file $cmd_file.bak

	sudo cp ./boot/config.txt $conf_file
	sudo cp /boot/cmdline.txt $cmd_file
}


mnt_stubs() {
	local mnt_root=/media/pi

	[ ! -d "$mnt_root" ] && sudo mkdir -p $mnt_root
	for i in `seq 0 4`; do
		[ ! -d "$mnt_root/usb$i" ] && sudo mkdir -p ${mnt_root}/usb${i}
	done

	#-- make symlinks to 1st usb
	if [ ! -s "$mnt_root/usb" ]; then
		cd $mnt_root
		sudo ln -s ./usb0 usb
	fi

	if [ ! -s $mnt_root/usb ]; then
		cd $mnt_root/../
		sudo ln -s ./pi/usb
	fi

	if [ ! -s /home/pi/usb ]; then
		cd /home/pi
		ln -s $mnt_root/usb
	fi

	#-- apply ownership + access
	sudo chown -R root:adm $mnt_root
	sudo chmod -R 775 $mnt_root
}


change_locale() {
	local locale=en_US.UTF-8
	local locale_opts=$(locale | awk -F\= '~/[^en_US.UTF-8]/{print}')

	if [ ! -z "$locale_opts" ]; then
		sudo sed -Ei 's/# (en_US.*)/\1/g' /etc/locale.gen | grep en_US
		sudo locale-gen

		locale_opts=$(locale | awk -F\= '{if (length($NF) == 0) printf "%s=en_US.UTF-8\n",$1}')
		[ ! -z "$locale_opts" ] && sudo locale-update "$locale_opts"
	fi

	sudo localectl set-locale $locale
}




clear
printf "Replacing boot configs..."
boot_config
echo

printf "Creating mount pt stub dirs at %s..." "/media/pi"
mnt_stubs
echo

printf "Changing locale to %s..." "en_US.UTF-8"
change_locale
echo

printf "Setup Complete! Press any key to reboot...\n"
input
sudo reboot



exit 0;


