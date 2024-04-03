# VM Configurations
Contents (per machine):
- VirtualBox: creation scripts
- VirtualBox: preseed configs
- Bash: setup scripts


## Attack
Creation guide

1. Use latest Debain ISO [here](https://www.debian.org/distrib/) (small USB, amd64)
2. VM Settings:
    - Name: Attack
    - Memory: 2GB+
    - HDD: 32GB+
    - Shared Clip: Bidirectional
    - CPU: 2+
    - VRAM: 32MB+
    - Shared Folder: /opt/htb
3. Install Options:
    - Hostname: attack.gingerbread.space
    - Root Pass: None
    - User: gbm
    - Desktop: Xfce
    - Software: None
4. Setup:
    - Panel: Use default config
    - Run [setup](https://github.com/aidan-gbm/dotfiles/blob/master/vm/attack-setup.sh)
    