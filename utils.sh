#!/bin/bash



csec_sleep() {
    sleep `printf "%d.%02d" $(( (RANDOM % 1) + 0 )) $(( RANDOM % 100 ))`
}


bkup_file() {
    local src_file=$1
    local suffix="bkup" ; [ ! -z $2 ] && suffix=$2
    local bkup_file="${src_file}.${suffix}"
    local res=""

    if [ -f "$src_file" ]; then
        res=$(printf "Original file \`%s\` found" $src_file)
        if [ ! -f "$bkup_file" ]; then
            [ $pisetup_dr == false ] && sudo cp -p "${src_file}" "${bkup_file}"
            res=$(printf "%s\nDuplicated \`%s\` w/ suffix \`.%s\`\n" "${res}" `basename "$src_file"` "${suffix}")

        else
            res=$(printf "%s\nBackup file \`%s\` already exists, duplicating & appending \`.bak\`" "${res}" `basename "$bkup_file"`)
            [ $pisetup_dr == false ] && sudo cp -p "${src_file}" "${bkup_file}.bak"
        fi
    else res=$(printf "Source file \`%s\` not found, skipping\n" $src_file) ; fi

    printf "$res"
}


prompt_key() {
    local task="$1"

    echo
    read -n 1 -s -r -p "Completed ${task} setup! Press any key continue..." ; echo
}


prompt_reboot() {
    local task="$1"

    echo
    read -n 1 -s -r -p "Completed ${task} setup! Press any key to reboot..." && sudo reboot
}



export pisetup_dr=false
