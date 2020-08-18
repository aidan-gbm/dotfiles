# dotfiles
A collection of my dotfiles, including setup scripts for my common VMs.

## Config Files
- i3
  - [config](i3/config) - i3 config for Regolith
  - [config.arch](i3/config.arch) - i3 config for Arch
- i3blocks
  - i3blocks.conf - 2 variations on i3blocks configuration
  - [oscp](i3blocks/oscp) - custom network status for OSCP OpenVPN
- xfce4
  - [terminalrc](xfce4/terminalrc) - xfce4 terminal settings (used in Attack VM)
- [Scripts](Scripts/) - used in VM creation/setup
- [tmux.conf](tmux.conf)
- [bash_aliases](bash_aliases) - used in Attack VM
- [vimrc](vimrc)

## Attack VM
Debian 10 AMD64 image pulled from [Small CDs or USB sticks](https://www.debian.org/distrib/netinst). Setup on a Windows host with [creation script](scripts/attack-creation.ps1) (WIP). Run the [setup script](scripts/attack-setup.sh) after installation to configure the work environment.
