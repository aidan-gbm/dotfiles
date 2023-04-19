# dotfiles
A collection of my dotfiles, setup scripts, and ansible playbooks for my machines.

## Use

Use [ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
for ease of setup. Modify the host in `inventory.yml` as needed.

```
ansible-playbook -Ki inventory.yml development/playbook.yml
```

## Playbooks

- `development`: Debian 11 development VM

## Misc (old)

- i3
  - [config](i3/config) - i3 config for Regolith
  - [config.arch](i3/config.arch) - i3 config for Arch
- i3blocks
  - i3blocks.conf - 2 variations on i3blocks configuration
  - [oscp](i3blocks/oscp) - custom network status for OSCP OpenVPN
- xfce4
  - [terminalrc](xfce4/terminalrc) - xfce4 terminal settings (used in Attack VM)
- [vm](vm/) - used in VM creation/setup

## Attack VM (old)

Debian 10 AMD64 image pulled from [Small CDs or USB sticks](https://www.debian.org/distrib/netinst).
Setup on a Windows host with [creation script](vm/attack-creation.ps1) (WIP).
Run the [setup script](vm/attack-setup.sh) after installation to configure the work environment.
