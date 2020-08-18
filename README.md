# dotfiles
A collection of my dotfiles, including setup scripts for my common VMs.

## VirtualBox Management
Run the [vbox.ps1](scripts/vbox.ps1) script to enable VirtualBox management via PowerShell on the host computer.

## Attack VM
Debian 10 AMD64 image pulled from [Small CDs or USB sticks](https://www.debian.org/distrib/netinst). Setup on a Windows host with [creation script](scripts/attack-creation.ps1) (WIP). Run the [setup script](scripts/attack-setup.sh) after installation to configure the work environment.
