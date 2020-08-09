#!/usr/bin/env bash

# Add gbm to sudoers
# su -c 'gpasswd -a gbm sudo'

# Install guest additions
# sudo apt update
# sudo apt install -y build-essential dkms linux-headers-$(uname -r)
# ( Insert Guest Additions CD from VBox Menu )
# sudo mkdir /mnt/cdrom
# sudo mount /dev/cdrom /mnt/cdrom
# cd /mnt/cdrom
# sudo ./autorun.sh
# sudo reboot

prompt() {
    echo $1
    read -n 1 -srp 'Press any key to continue...'
    echo
}

# Modify /opt for use by gbm
sudo chown root:gbm /opt
sudo chmod g+w /opt

# Add gbm to vboxsf group
sudo adduser gbm vboxsf

# Harden SSH Server
sudo sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config
sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo sed -i 's/#PermitEmptyPasswords no/PermitEmptyPasswords no/' /etc/ssh/sshd_config
sudo systemctl restart sshd

# Add add-apt-repository
sudo apt-get install -y software-properties-common
sudo apt update

# Add Visual Studio Code repository
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
sudo apt update

# General Programs
sudo apt install -y curl code git openvpn tmux vim python-pip python3-pip gcc-multilib default-jdk

# Hacking Programs
sudo apt install -y nmap ncat rlwrap tcpdump python-impacket ltrace gdb cmake

# Python Modules
pip install --user requests colorama pwntools

# Seclists
mkdir /opt/enum
git clone https://github.com/danielmiessler/SecLists.git /opt/enum/seclists

# Get dotfiles
git clone https://github.com/aidan-mccarthy/dotfiles.git /opt/dotfiles
cp /opt/dotfiles/bash_aliases ~/.bash_aliases
cp /opt/dotfiles/vimrc ~/.vimrc

# Metasploit
curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > /tmp/msfinstall
chomd +x /tmp/msfinstall
/tmp/msfinstall

# Fix MySQL after Metasploit
sudo systemctl stop mysql
sudo systemctl disable mysql

# Personalization
wget -O ~/Pictures/debian.png https://wiki.debian.org/DebianArt/Themes/sharp?action=AttachFile&do=get&target=sharp_wallpaper_1920x1200.png
xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/workspace0/last-image -s ~/Pictures/debian.png
cp /opt/dotfiles/xfce4/xsettings.xml ~/.config/xfce4/xfce-perchannel-xml/xsettings.xml
cp /opt/dotfiles/xfce4/terminalrc ~/.config/xfce4/terminal/terminalrc

# Clean Up
sudo apt -y autoremove
source ~/.bashrc

## MANUAL INSTALLATION

# Burp Suite
prompt 'Manual Install: Burp Suite -> https://portswigger.net/burp/releases/community/latest'

# Firefox Addons
prompt 'Manual Install: Firefox Cookie Editor -> https://addons.mozilla.org/en-US/firefox/addon/cookie-editor/?src=search'
prompt 'Manual Install: Firefox FoxyProxy -> https://addons.mozilla.org/en-US/firefox/addon/foxyproxy-standard/?src=search'
