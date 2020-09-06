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
		sudo sed -Ei 's/#Uncomment/\n#Uncomment/g' $deb_file
		sudo sed -Ei 's/#deb-src/deb-src/g' $deb_file
		sudo sed -Ei 's/#Uncomment/\n#Uncomment/g' $rpi_file
		sudo sed -Ei 's/#deb-src/deb-src/g' $rpi_file
	fi
	echo ; echo
}


apt_upg() {
    printf "Updating apt src...\n"
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
#    echo $pkgs | awk 'BEGIN {RS=" "} ; {print length($0),$0}' | awk 'BEGIN {max=0 ; tot=0} ; {if($1 > max) max=$1 ; arr[$1]=$0 ; tot=tot+1} ; END {print arr[max]}'

#    local pkgs_ins=$(apt list 2> /dev/null | grep installed | tr ' ' '%')
    local pkgs_ins=$(apt list 2> /dev/null | grep installed)
#    local req=$(echo $$pkgs | gawk 'BEGIN {RS=" "} ;  {for(i=0; i<NR; i++) arr[$i]=$0}')
#    echo $$pkgs | tr ' ' '\n' | tr '%' ' ' | gawk 'BEGIN {RS=" "} ; {for(i=0; i<NR; i++) arr[$i]=$0} ; END {print arr[0]}'
#    echo $pkgs | gawk -v ins=$pkgs_ins 'BEGIN {RS=" "} ; {for(i=0; i<NR; i++) arr[$i]=$0} ; END {print arr[0]}'
    echo $pkgs | gawk 'BEGIN {RS=" "} ; {for(i=0; i<NR; i++) print i,$0}' | awk -v p=$pkgs_ins '{print $0}'
#gawk 'BEGIN {RS=" "} ; {for(i=0; i<NR; i++) arr[i]=$0 ; print $0} ; {for(i=0; i<NR; i++) if(!/^hfsutils\/stable END {print arr[0]}'; END {print arr[0]}'

#    echo $$pkgs | gawk 'BEGIN {RS=" "} ; {for(i=0; i<NR; i++) arr[i]=$0 ; print $i,$0}'

#    local pkgs_tot=$(wc -l $pkgs_ins)
#    local pkgs_drp=$(    local pkgs_tot=$(apt list | grep -c installed)

#    echo $pkgs | awk 'BEGIN {RS=" "} ; {print length($0),$0}' | gawk 'BEGIN {max=0 ; tot=0} ; {if($1 > max) max=$1 ; arr[tot]=$2 ; tot=tot+1} ; END {for(i=0; i<tot-1; i++) printf "[%*s]\n",(max),arr[i]}' | tr ' ' '.' | sed -E 's/([a-z\-]+)/ \1 /g'
    echo $pkgs | awk 'BEGIN {RS=" "} ; {print length($0),$0}' | gawk 'BEGIN {max=0 ; tot=0} ; {if($1 > max) max=$1 ; arr[tot]=$2 ; tot=tot+1} ; END {for(i=0; i<tot-1; i++) printf "[%*s]\n",(max),arr[i]}' | tr ' ' '.' | sed -E 's/([a-z\-]+)/ \1 /g'


    printf "Installing:\n"
#    echo $pkgs_lst | awk '{printf "[%(pkg_max+1)s ]\n",$0}'
#    echo $pkgs_lst
#    echo $pkgs_lst | awk '{print length($0),$0}' | awk 'BEGIN {max=0 ; tot=0} ; {if($1 > max) max=$1 ; arr[$1]=$0} ; END {print arr[max]}'
    if [ $dry_run == true ]; then sleep_dr
    else
        sudo apt install -y $pkgs
    fi
    echo
}


apt_cleanup() {
    printf "Autocleaning & autoremoving...\n"
    if [ $dry_run == true ]; then sleep_dr
    else
        printf "Autocleaning..."
        sudo apt autoremove -y
        printf "\nAutoremoving..."
        sudo apt autoclean -y
    fi
    echo
}


dry_run=false
[ $1 == "false" ] && dry_run=true


clear
[ $dry_run == "true" ] && printf "Setup apt --dry-run\n\n"


printf "Enabling deb-src packages in sources.list...\n"
apt_src ; echo

printf "Updating & upgrading...\n"
apt_upg ; echo

printf "Prepping preliminary packages...\n"
apt_inst ; echo

printf "Auto removing & cleaning...\n"
apt_cleanup ; echo

#read -n 1 -s -r -p "Setup complete!, press any key to reboot..." && sudo reboot
read -n 1 -s -r -p "Setup complete!, press any key to reboot..."


exit 0;


