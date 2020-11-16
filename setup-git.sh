#!/bin/bash


github_email="code@solutionsmatty.com"
github_username="gullinbursti"


git_globals() {
    printf "Configuring git globals..."

    printf " color.ui as (auto)…"
    git config --global color.ui "auto"

    printf " core.pager as (less -R)…"
    git config --global core.pager "less -R"

    printf " user.name as (%s)…" "$1"
    git config --global user.name $1

    printf " user.email as (%s)…" "$2"
    git config --global user.email $2

    printf " credential.helper as (store)…"
    git config --global credential.helper "store"
}


git_creds() {
#    echo "https://gullinbursti:317a23d5b261a5a5557832d5f303036388be591c@github.com" > ~/.git-credentials
#    chmod 600 ~/.git-credentials
}


clear
printf "Configuring for git + prepping GitHub\n[%s=]\n\n" "`printf '=-'%.0s {1..18}`"
git_globals "${github_username}" "${github_email}"

printf "Hard writing git creds..."
git_creds


echo ; read -n 1 -s -r -p "Completed git setup / cfg! Press any key to quit." && echo ; echo


exit 0;
