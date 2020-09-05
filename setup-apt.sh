#!/bin/bash



apt_src() {
	local deb_file=/etc/apt/sources.list
	local rpi_file=/etc/apt/sources.list.d/raspi.list

	printf "Backing up prev src lists..."
	[ -f "$deb_file" ] && sudo cp $deb_file $deb_file.bak
	[ -f "$rpi_file" ] && sudo cp $rpi_file $rpi_file.bak
	echo

	printf "Uncommenting deb-src..."
	sudo sed -Ei 's/#Uncomment/\n#Uncomment/g' $deb_file
	sudo sed -Ei 's/#deb-src/deb-src/g' $deb_file

	sudo sed -Ei 's/#Uncomment/\n#Uncomment/g' $rpi_file
	sudo sed -Ei 's/#deb-src/deb-src/g' $rpi_file
	echo ; echo
}


apt_upg() {
    printf "Updating & upgrading apt...\n"
    sudo apt update
    sudo apt upgrade -y
    echo
}


apt_inst() {
    local pkgs="bc exfat-utils git hfsutils jq pv source-highlight sysbench tmux wget"

    printf "Installing packages:\n"
    echo $pkgs | awk -F\  '{printf "%-30s\n",$0}'
    sudo apt install -y $pkgs
    echo
}


apt_cleanup() {
    printf "Autocleaning & autoremoving...\n"
    sudo apt autoremove -y
    sudo apt autoclean -y
    echo
}



clear
printf "Enabling deb-src packages in sources.list:\n"
apt_src

printf "Updating & upgrading apt:\n"
apt_upg

printf "\nInstalling preliminary packages:\n"
apt_inst

printf "\nAuto removing & cleaning:\n"
apt_cleanup

read -n 1 -s -r -p "\nSetup complete!, press any key to reboot..."


exit 0;


