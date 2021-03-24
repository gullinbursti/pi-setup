#!/bin/bash



github_email="code@solutionsmatty.com"
github_username="gullinbursti"



git_creds() {
    printf "Setting access token...\n"
    echo "https://gullinbursti:317a23d5b261a5a5557832d5f303036388be591c@github.com" > /home/pi/.git-credentials
    chmod 600 /home/pi/.git-credentials
}


git_globals() {
    printf "Configuring git globals...\n"

    printf "\t- color.ui as (auto)\n"
    git config --global color.ui "auto"

    printf "\t- core.pager as (less -R)\n"
    git config --global core.pager "less -R"

    printf "\t- user.name as (%s)\n" "$1"
    git config --global user.name $1

    printf "\t- user.email as (%s)\n" "$2"
    git config --global user.email $2

    printf "\t- credential.helper as (store)\n"
    git config --global credential.helper "store"
}



clear
printf "Configuring for git + prepping GitHub\n[%s=]\n\n" "`printf '=-'%.0s {1..18}`"
git_globals "${github_username}" "${github_email}"

#printf "Hard writing git creds..."
#git_creds


echo ; read -n 1 -s -r -p "Completed git setup / cfg! Press any key to quit." && echo ; echo


exit 0;
