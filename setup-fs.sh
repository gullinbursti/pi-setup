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


apt_src() {
	local deb_file=/etc/apt/sources.list
	local rpi_file=/etc/apt/sources.list.d/raspi.list

	[ -f "$deb_file" ] && sudo cp $deb_file.bak
	[ -f "$rpi_file" ] && sudo cp $rpi_file.bak

	sudo sed -Ei 's/#Uncomment/\n#Uncomment/g' $deb_file
	sudo sed -Ei 's/#deb-src/deb-src/g' $deb_file

	sudo sed -Ei 's/#Uncomment/\n#Uncomment/g' $rpi_file
	sudo sed -Ei 's/#deb-src/deb-src/g' $rpi_file
}


console_font() {
	local font_file=/etc/default/console-setup
	[ -f "$font_file" ] && sudo cp $font_file.bak

	sudo sed -Ei 's/FONTFACE.*/FONTFACE="Terminus"/g' $font_file
	sudo sed -Ei 's/FONTSIZE.*/FONTSIZE="8x16"/g' $font_file

	sudo systemctl restart console-setup.service
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

printf "Creating group 'wheel' & adding user 'pi' to it + 'staff' groups..."
group_mod
echo

printf "Creating mount pt stub dirs at %s..." "/media/pi"
mnt_stubs
echo

printf "Enabling \`apt-get source\`..."
apt_src
echo

printf "Changing console font to %s / %s...\n" "Terminus" "8x16"
console_font

printf "Changing locale to %s..." "en_US.UTF-8"
change_locale
echo

printf "Setup Complete! Press any key to reboot...\n"
input
sudo reboot



exit 0;


