#!/bin/bash



sleep_dr() { sleep `printf "%d.%02d" $(( (RANDOM % 1) + 0 )) $(( RANDOM % 100 ))` ;}


apt_src() {
	local deb_file=/etc/apt/sources.list
	local rpi_file=/etc/apt/sources.list.d/raspi.list

	printf "Backing up prev src lists..."
	if [ $dry_run == true ]; then sleep_dr
	else
		[ -f "$deb_file" ] && sudo cp $deb_file $deb_file.bak
		[ -f "$rpi_file" ] && sudo cp $rpi_file $rpi_file.bak
	fi
	echo

	printf "Uncommenting deb-src..."
	if [ $dry_run == true ]; then sleep_dr
	else
		sudo sed -Ei 's/# Uncomment/\n# Uncomment/g' $deb_file
		sudo sed -Ei 's/#deb-src/deb-src/g' $deb_file
		sudo sed -Ei 's/# Uncomment/\n# Uncomment/g' $rpi_file
		sudo sed -Ei 's/#deb-src/deb-src/g' $rpi_file
	fi
	echo ; echo
}


apt_upg() {
    if [ $dry_run == true ]; then sleep_dr ; printf "Upgrading installed pkgs...\n" ; sleep_dr

    else
        sudo apt update ; echo
        printf "Upgrading installed pkgs...\n"
        sudo apt upgrade -y
    fi
    echo
}


apt_inst() {
    local pkgs="bc exfat-utils git hfsutils jq pv source-highlight sysbench tmux wget"
#    local pkgs_ins=$(apt list 2> /dev/null | grep installed)

    echo $pkgs | awk 'BEGIN {RS=" "} ; {print length($0),$0}' | gawk 'BEGIN {max=0 ; tot=0} ; {if($1 > max) max=$1 ; arr[tot]=$2 ; tot=tot+1} ; END {for(i=0; i<tot-1; i++) printf "[%*s]\n",(max),arr[i]}' | tr ' ' '.' | sed -E 's/([a-z\-]+)/ \1 /g' ; echo

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



printf "Enabling deb-src packages in sources.list...\n"
apt_src ; echo

printf "Updating & upgrading...\n"
apt_upg ; echo

printf "Prepping preliminary packages for install...\n"
apt_inst ; echo

printf "Auto removing + auto clean up...\n"
apt_cleanup ; echo


read -n 1 -s -r -p "Setup complete for apt!, press any key to reboot..." && sudo reboot


exit 0;
