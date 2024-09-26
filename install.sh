#!/usr/bin/env sh

info() {
    echo "[+] $*"
}

fail() {
    echo "[-] $*"
    exit 1
}

### Install Dependencies ###

if ! test -f /etc/os-release; then
    fail cannot determine OS
fi

OS=$(sed -nr 's/^ID=(.*)$/\1/p' /etc/os-release)

case $OS in
    alpine)
        alias update='sudo apk -qq update'
        alias install='sudo apk -qq add'
        ;;
    debian|ubuntu)
        export DEBIAN_FRONTEND=noninteractive
        alias update='sudo -E apt-get -qq update'
        alias install='sudo -E apt-get -qq install'
        ;;
    *)
        fail unsupported OS: $OS ;;
esac

info installing dependencies for $OS
update && install python3 python3-venv

### Setup Python Virtual Environment ###

venv="$HOME/.local/venv"

if test -d "$venv"; then
    system=$(sed -nr 's/.*-site-packages = (\w+)/\1/p' "$venv/pyvenv.cfg")
    if test "$system" = "true"; then
        info using existing virtual environment
    else
        fail existing environment does not include system site packages
    fi
else
    info creating virtual environment
    python3 -m venv --system-site-packages "$venv"
fi

. "$venv/bin/activate"

### Run Ansible Playbook ###

info installing ansible
pip install -qq --user ansible

repo=$(dirname -- "$0")
if ! test -f "$repo/development.yml"; then
    fail cannot locate playbook
fi

ansible-playbook -K "$repo/development.yml"

if test $? -eq 0; then
    info setup complete
else
    fail ansible failed
fi
