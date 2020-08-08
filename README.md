# dotfiles

## Attack VM
Debain amd64 image pulled from [Small CDs or USB sticks](https://www.debian.org/distrib/netinst).

Setup with [setup script](Scripts/attack-setup.sh).

## Gnome Terminal
Export profiles with: `dconf dump /org/gnome/terminal/legacy/profiles:/ > profiles.dconf`

Import profiles with: `dconf load /org/gnome/terminal/legacy/profiles:/ < profiles.dconf`
