#!/bin/bash


github_email="biflindi.fjolnir@gmail.com"
github_username="gullinbursti"


git_globals() {
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

    printf " credential.usePath as (true)…"
    git config --global credential.github.com.useHttpPath true
}


clear
printf "Configuring git / prepping GitHub…\n[%s=]\n" "`printf '=-'%.0s {1..18}`"

printf "\t - Configuring git globals…"
git_globals "${github_username}" "${github_email}"
echo


printf "Setup Complete!\n"


exit 0;
