#!/usr/bin/env bash

# Install guest additions
# sudo apt update
# sudo apt install -y build-essential dkms linux-headers-$(uname -r)
# ( Insert Guest Additions CD from VBox Menu )
# sudo mkdir /mnt/cdrom
# sudo mount /dev/cdrom /mnt/cdrom
# cd /mnt/cdrom
# sudo ./autorun.sh
# sudo reboot

$USER=`whoami`

msg() { echo -e "\e[34m[-] $*\e[0m"; }
win() { echo -e "\e[32m[+] $*\e[0m"; }
err() { echo -e "\e[91m[!] $*\e[0m"; }

prompt() {
    echo $*
    read -n 1 -srp 'Press any key to continue...'
    echo
}

# Modify /opt for use by gbm
msg "Giving $USER control of /opt"
sudo chown root:gbm /opt
sudo chmod g+w /opt

# Add gbm to vboxsf group
msg "Adding $USER to vboxsf group"
sudo adduser gbm vboxsf

# Add add-apt-repository
msg "Getting add-apt-repository command"
sudo apt-get install -qqy software-properties-common >/dev/null
sudo apt update >/dev/null
win "Done!"

# Add Visual Studio Code repository
msg "Adding Visual Studio Code repository"
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
sudo apt update >/dev/null
win "Done!"

# General Programs
msg "Installing general programs"
sudo apt install -qqy openssh-server curl code git openvpn tmux vim python-pip python3-pip gcc-multilib default-jdk mariadb-server >/dev/null
win "Done!"

# Hacking Programs
msg "Installing various hacking tools"
sudo apt install -qqy nmap ncat rlwrap tcpdump python-impacket ltrace gdb cmake >/dev/null
win "Done!"

# Install Go
msg "Installing Go"
wget -P /tmp 'https://golang.org/dl/go1.15.linux-amd64.tar.gz'
sudo tar -C /usr/local -xzf /tmp/go1.15.linux-amd64.tar.gz
echo "export GOROOT=/usr/local/go" >> ~/.bashrc
echo "export GOPATH=$HOME/.go" >> ~/.bashrc
echo "export PATH=$PATH:$GOROOT:$GOPATH/bin" >> ~/.bashrc
source ~/.bashrc
win "Done!"

# Install gobuster
msg "Installing gobuster"
go get github.com/OJ/gobuster
win "Done!"

# Disable default MySQL startup
msg "Disabling default MySQL startup"
sudo systemctl stop mysql >/dev/null
sudo systemctl disable mysql >/dev/null

# Harden SSH Server
msg "Hardening SSH server"
sudo sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config
sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo sed -i 's/#PermitEmptyPasswords no/PermitEmptyPasswords no/' /etc/ssh/sshd_config
sudo systemctl restart sshd

# Python Modules
msg "Installing various Python 2.7 modules"
pip install -q --user requests colorama pwntools
win "Done!"

# GDB PEDA
msg "Installing GDB PEDA -> /opt/misc/peda"
mkdir /opt/misc
git clone -q https://github.com/longld/peda.git /opt/misc/peda
echo 'source /opt/misc/peda/peda.py' >> ~/.gdbinit
win "Done!"

# Seclists
msg "Installing Seclists -> /opt/enum/seclists"
mkdir /opt/enum
git clone -q https://github.com/danielmiessler/SecLists.git /opt/enum/seclists
win "Done!"

# Get dotfiles
msg "Getting dotfiles repo -> /opt/dotfiles"
git clone -q https://github.com/aidan-mccarthy/dotfiles.git /opt/dotfiles
cp /opt/dotfiles/bash_aliases ~/.bash_aliases
cp /opt/dotfiles/vimrc ~/.vimrc
win "Done!"

# Metasploit
msg "Installing Metasploit"
curl 'https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb' > /tmp/msfinstall
chmod +x /tmp/msfinstall
/tmp/msfinstall 2>/dev/null
win "Done!"

# Personalization
msg "Adding desktop personalization"
wget -O ~/Pictures/debian.png 'https://wiki.debian.org/DebianArt/Themes/sharp?action=AttachFile&do=get&target=sharp_wallpaper_1920x1200.png'
xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/workspace0/last-image -s ~/Pictures/debian.png
xfconf-query -c xsettings -p /Net/ThemeName -s "Adwaita-dark"
cp /opt/dotfiles/xfce4/terminalrc ~/.config/xfce4/terminal/terminalrc

# Clean Up
msg "Cleaning up..."
sudo apt -y autoremove
source ~/.bashrc

## MANUAL INSTALLATION

# Burp Suite
prompt $(msg 'Manual Install: Burp Suite -> https://portswigger.net/burp/releases/community/latest')

# Firefox Addons
prompt $(msg 'Manual Install: Firefox Cookie Editor -> https://addons.mozilla.org/en-US/firefox/addon/cookie-editor/?src=search')
prompt $(msg 'Manual Install: Firefox FoxyProxy -> https://addons.mozilla.org/en-US/firefox/addon/foxyproxy-standard/?src=search')
