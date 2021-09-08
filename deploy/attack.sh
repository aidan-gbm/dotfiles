#!/usr/bin/env bash

USER=$(logname)
HOME="/home/$USER"

if [ $USER == "root" ]; then
    HOME="/root"
fi

msg() { echo -e "\e[94m[-] $*\e[0m"; }
win() { echo -e "\e[32m[+] $*\e[0m"; }
err() { echo -e "\e[91m[!] $*\e[0m"; }

if [[ $EUID -ne 0 ]]; then
    err "Must be run as root."
    exit 1
fi

prompt_yn() {
    read -r -p "$* (y/n): " response
    case "$response" in
    [yY]) 
        return 0
        ;;
    [nN])
        return 1
        ;;
    *)
        echo "Must answer (y)es or (n)o."
        prompt_yn "$*"
        ;;
    esac
}

prompt() {
    echo $*
    read -n 1 -srp 'Press any key to continue...'
    echo
}

aptInstall() {
    echo -n "$1..."
    apt-get -qq install $1 >/dev/null
    if [[ $? -eq 0 ]]; then
        echo "done!"
        return 0
    else
        echo "failed!"
        return 1
    fi
}

# Install guest additions
prompt_yn "Do you want to install VirtualBox Guest Additions?"
if [[ $? -eq 0 ]]; then
    msg "Installing VBox Guest Additions..."
    apt-get -qq update
    aptInstall build-essential && \
    aptInstall dkms && \
    aptInstall linux-headers-$(uname -r)

    if [[ $? -eq 0 ]]; then
        prompt "Insert Guest Additions CD from VBox Menu"
        mkdir /mnt/cdrom
        mount /dev/cdrom /mnt/cdrom
        /mnt/cdrom/autorun.sh && \
        win "Done"
    else
        err "Could not install required packages."
        break
    fi
else
    msg "Skipping VBox Guest Additions Install..."
fi

# Modify /opt for use by current user
msg "Giving $USER control of /opt"
chown root:$USER /opt
chmod g+w /opt

# Add gbm to vboxsf group
msg "Adding $USER to vboxsf group"
adduser $USER vboxsf >/dev/null

# General Programs
msg "Installing general purpose tools."
aptInstall software-properties-common && \
aptInstall openssh-server && \
aptInstall wget && \
aptInstall curl && \
aptInstall git && \
aptInstall openvpn && \
aptInstall tmux && \
aptInstall vim && \
aptInstall python3.9 && \
aptInstall python3-pip && \
aptInstall gcc-multilib && \
aptInstall default-jdk && \
aptInstall mariadb-server && \
aptInstall cmake && \
apt-get -qq update && \
win "Done!" || \
err "Could not install required package."

# Hacking Programs
msg "Installing hacking related tools."
aptInstall nmap && \
aptInstall ncat && \
aptInstall rlwrap && \
aptInstall tcpdump && \
aptInstall python3-impacket && \
aptInstall ltrace && \
aptInstall gdb && \
aptInstall nfs-common && \
aptInstall ftp && \
win "Done!" || \
err "Could not install required package."

# Add Visual Studio Code repository
msg "Adding Visual Studio Code repository"
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
apt-get -qq update
aptInstall code && \
win "Done!" || \
err "Could not install VSCode."

# Get dotfiles
msg "Getting dotfiles repo -> /opt/dotfiles"
sudo -u $USER git clone -q https://github.com/aidan-gbm/dotfiles.git /opt/dotfiles
sudo -u $USER /opt/dotfiles/setup.sh /opt/dotfiles && \
win "Done!"

# Install Go
msg "Installing Go"
wget -q -P /tmp 'https://golang.org/dl/go1.15.linux-amd64.tar.gz'
tar -C /usr/local -xzf /tmp/go1.15.linux-amd64.tar.gz
echo "export GOPATH=$HOME/.go" >> $HOME/.bashrc
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/.go/bin" >> $HOME/.bashrc
source $HOME/.bashrc
win "Done!"

# Install gobuster
msg "Installing gobuster"
/usr/local/go/bin/go install github.com/OJ/gobuster/v3@latest
win "Done!"

# Disable default MySQL startup
msg "Disabling default MySQL startup"
systemctl stop mysql >/dev/null
systemctl disable mysql >/dev/null

# Harden SSH Server
msg "Hardening SSH server"
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
sed -i 's/#PermitEmptyPasswords no/PermitEmptyPasswords no/' /etc/ssh/sshd_config
systemctl restart sshd

# Python Modules
msg "Installing Python modules"
sudo -u $USER python3.9 -m pip install -q --user requests colorama pwntools --no-warn-script-location
win "Done!"

# GDB GEF
msg "Installing GDB GEF"
wget -q -O /tmp/gef.sh https://github.com/hugsy/gef/raw/master/scripts/gef.sh
sudo -Hu $USER bash /tmp/gef.sh
win "Done!"

# Seclists
msg "Installing Seclists -> /opt/enum/seclists"
sudo -u $USER mkdir /opt/enum
sudo -u $USER git clone -q --progress https://github.com/danielmiessler/SecLists.git /opt/enum/seclists
win "Done!"

# # Metasploit
# msg "Installing Metasploit"
# curl -s 'https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb' > /tmp/msfinstall
# chmod +x /tmp/msfinstall
# /tmp/msfinstall
# win "Done!"

# Personalization
msg "Adding desktop personalization"
wget -q -O $HOME/Pictures/debian.png 'https://wiki.debian.org/DebianArt/Themes/sharp?action=AttachFile&do=get&target=sharp_wallpaper_1920x1200.png'
#sudo -u $USER xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/workspace0/last-image -s $HOME/Pictures/debian.png
#sudo -u $USER xfconf-query -c xsettings -p /Net/ThemeName -s "Adwaita-dark"
cp /opt/dotfiles/xfce4/terminalrc $HOME/.config/xfce4/terminal/terminalrc

# Clean Up
msg "Cleaning up..."
apt -y autoremove >/dev/null
win "Done!"

# ## MANUAL INSTALLATION

# # Burp Suite
# prompt $(msg 'Manual Install: Burp Suite -> https://portswigger.net/burp/releases/community/latest')

# # Firefox Addons
# prompt $(msg 'Manual Install: Firefox Cookie Editor -> https://addons.mozilla.org/en-US/firefox/addon/cookie-editor/?src=search')
# prompt $(msg 'Manual Install: Firefox FoxyProxy -> https://addons.mozilla.org/en-US/firefox/addon/foxyproxy-standard/?src=search')
# msg 'Complete Metasploit install with "msfconsole"'
# win "Completed Attack setup!"
