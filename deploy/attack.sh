#!/usr/bin/env bash

USER=$(logname)

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
    apt-get install -qq $1 2>/dev/null
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
    apt-get update -qq
    aptInstall build-essential && \
    aptInstall dkms && \
    aptInstall linux-headers-$(uname -r)

    if [[ $? -eq 0 ]]; then
        prompt "Insert Guest Additions CD from VBox Menu"
        mkdir /mnt/cdrom
        mount /dev/cdrom /mnt/cdrom
        ./mnt/cdrom/autorun.sh && \
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
apt-get update -qq && \
win "Done!" || \
err "Could not install required package."

# Hacking Programs
msg "Installing hacking related tools."
aptInstall nmap && \
aptInstall ncat && \
aptInstall rlwrap && \
aptInstall tcpdump && \
aptInstall python-impacket && \
aptInstall ltrace && \
aptInstall gdb && \
aptInstall nfs-common && \
aptInstall ftp && \
win "Done!" || \
err "Could not install required package."

# # Add Visual Studio Code repository
# msg "Adding Visual Studio Code repository"
# apt-get install wget
# wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
# sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
# sudo apt-get update >/dev/null
# sudo apt-get install -y code
# win "Done!"

# # Get dotfiles
# msg "Getting dotfiles repo -> /opt/dotfiles"
# git clone -q https://github.com/aidan-mccarthy/dotfiles.git /opt/dotfiles
# cp /opt/dotfiles/vm/attack-aliases ~/.bash_aliases
# cp /opt/dotfiles/bashrc ~/.bashrc
# cp /opt/dotfiles/vimrc ~/.vimrc
# source ~/.bashrc
# win "Done!"

# # Install Go
# msg "Installing Go"
# wget -q -P /tmp 'https://golang.org/dl/go1.15.linux-amd64.tar.gz'
# sudo tar -C /usr/local -xzf /tmp/go1.15.linux-amd64.tar.gz
# echo "export GOPATH=$HOME/.go" >> ~/.bashrc
# echo "export PATH=$PATH:/usr/local/go/bin:$HOME/.go/bin" >> ~/.bashrc
# source ~/.bashrc
# win "Done!"

# # Install gobuster
# msg "Installing gobuster"
# go get github.com/OJ/gobuster
# win "Done!"

# # Disable default MySQL startup
# msg "Disabling default MySQL startup"
# sudo systemctl stop mysql >/dev/null
# sudo systemctl disable mysql >/dev/null

# # Harden SSH Server
# msg "Hardening SSH server"
# sudo sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config
# sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
# sudo sed -i 's/#PermitEmptyPasswords no/PermitEmptyPasswords no/' /etc/ssh/sshd_config
# sudo systemctl restart sshd

# # Python Modules
# msg "Installing Python modules"
# python -m pip install -q --user requests colorama pwntools --no-warn-script-location
# python3 -m pip install -q --user requests colorama pwntools --no-warn-script-location
# win "Done!"

# # GDB PEDA
# msg "Installing GDB PEDA -> /opt/misc/peda"
# mkdir /opt/misc
# git clone -q https://github.com/longld/peda.git /opt/misc/peda
# echo 'source /opt/misc/peda/peda.py' >> ~/.gdbinit
# win "Done!"

# # Seclists
# msg "Installing Seclists -> /opt/enum/seclists"
# mkdir /opt/enum
# git clone -q --progress https://github.com/danielmiessler/SecLists.git /opt/enum/seclists
# win "Done!"

# # Metasploit
# msg "Installing Metasploit"
# curl -s 'https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb' > /tmp/msfinstall
# chmod +x /tmp/msfinstall
# /tmp/msfinstall
# win "Done!"

# # Personalization
# msg "Adding desktop personalization"
# wget -q -O ~/Pictures/debian.png 'https://wiki.debian.org/DebianArt/Themes/sharp?action=AttachFile&do=get&target=sharp_wallpaper_1920x1200.png'
# xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/workspace0/last-image -s ~/Pictures/debian.png
# xfconf-query -c xsettings -p /Net/ThemeName -s "Adwaita-dark"
# cp /opt/dotfiles/xfce4/terminalrc ~/.config/xfce4/terminal/terminalrc

# # Clean Up
# msg "Cleaning up..."
# sudo apt -y autoremove >/dev/null
# win "Done!"

# ## MANUAL INSTALLATION

# # Burp Suite
# prompt $(msg 'Manual Install: Burp Suite -> https://portswigger.net/burp/releases/community/latest')

# # Firefox Addons
# prompt $(msg 'Manual Install: Firefox Cookie Editor -> https://addons.mozilla.org/en-US/firefox/addon/cookie-editor/?src=search')
# prompt $(msg 'Manual Install: Firefox FoxyProxy -> https://addons.mozilla.org/en-US/firefox/addon/foxyproxy-standard/?src=search')
# msg 'Complete Metasploit install with "msfconsole"'
# win "Completed Attack setup!"
