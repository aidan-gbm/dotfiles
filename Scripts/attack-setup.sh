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

# Setup shared folder for hacking SSD
echo "cd ~/hacking/htb; alias htb=\"tmux new-session -s HTB -d 'sudo openvpn ~/hacking/htb/gingerbreadman.ovpn' \\; attach\"" > ~/.bash_aliases

function prompt {
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

# Install programs
sudo apt install -y curl code git openvpn tmux vim

# Seclists
mkdir /opt/enum
git clone https://github.com/danielmiessler/SecLists.git /opt/enum/seclists

# Get dotfiles
git clone https://github.com/aidan-mccarthy/dotfiles.git /opt/dotfiles
cp /opt/dotfiles/vimrc ~/.vimrc

## MANUAL INSTALLATION

# Burp Suite
prompt 'Manual Install: Burp Suite -> https://portswigger.net/burp/releases/community/latest'

# Firefox Addons
prompt 'Manual Install: Firefox Cookie Editor -> https://addons.mozilla.org/en-US/firefox/addon/cookie-editor/?src=search'
prompt 'Manual Install: Firefox FoxyProxy -> https://addons.mozilla.org/en-US/firefox/addon/foxyproxy-standard/?src=search'
