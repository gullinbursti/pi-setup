#!/bin/bash



user_grps() {
	local grps_add="staff"

	sudo usermod --groups "$grps_add" --append pi
}


bash_sys() {
	local rc_file=/etc/bash.bashrc

	#-- backup & append rc
	if [ -f "$rc_file" ]; then sudo cp -p $rc_file $rc_file.bak ; fi
	sudo printf "\n\n#-- appended by pi-setup\n" >> $rc_file
	sudo cat ./etc/bash.bashrc >> $rc_file
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


console_font() {
	local console_file=/etc/default/console-setup
	[ -f "$console_file" ] && sudo cp -p $console_file $console_file.bak

	sudo printf "\n\n#-- appended by pi-setup\n" >> $console_file
	sudo cat ./etc/default/console_setup >> $console_file

#	sudo sed -Ei 's/FONTFACE.*/FONTFACE="Terminus"/g' $font_file
#	sudo sed -Ei 's/FONTSIZE.*/FONTSIZE="8x16"/g' $font_file

	sudo systemctl restart console-setup.service
}


tmux() {
	local conf_file=/home/pi/.tmux.conf

	if [ -f "$conf_file" ]; then cp -p $conf_file $conf_file.bak ; fi
	cp -p ./home/pi/.tmux.conf $conf_file
}



clear
printf "Adding user 'pi' to group(s) %s...\n" "staff"
user_grps
echo

printf "Modifying system bash & nano /etc files..."
bash_sys
nano_sys
echo

printf "Modifying %s files..." "/home/pi"
bash_home
nano_home
tmux
echo

printf "Changing console font to Terminus / 8x16...\n"
console_font
echo

printf "Refreshing fs source..."
source /etc/profile
source /home/pi/.profile
echo


read -n 1 -s -r -p "Completed system + home cfg setup! Press any key to reboot..." && clear
sudo reboot


exit 0;
