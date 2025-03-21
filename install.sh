#!/usr/bin/env sh

info() {
    echo "[+] $*"
}

fail() {
    echo "[-] $*"
    exit 1
}

### Check Dependencies ###

python=$(command -v python3)
if test $? -ne 0; then
    fail missing python3 dependency
fi

if ! test -f /etc/os-release; then
    fail missing os-release - cannot verify OS
fi

OS=$(sed -nr 's/^ID=(.*)$/\1/p' /etc/os-release)

case $OS in
    debian|ubuntu)
        dpkg-query -S python3-venv >/dev/null 2>&1
        if test $? -ne 0; then
            fail missing python3-venv dependency
        fi
        ;;
    alpine) ;;
    *)
        fail unsupported OS: $OS
        ;;
esac

info validated dependencies

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
    $python -m venv --system-site-packages "$venv"
fi

. "$venv/bin/activate"
if test $? -ne 0; then
    fail could not activate python venv
fi

### Run Ansible Playbook ###

info installing ansible
pip install -qq --user ansible
if test $? -ne 0; then
    fail ansible install failed
fi

repo=$(dirname -- "$0")
playbook="$repo/main.yml"
if ! test -f "$playbook"; then
    fail cannot locate playbook $playbook
fi

export ANSIBLE_LOCALHOST_WARNING=False
export ANSIBLE_INVENTORY_UNPARSED_WARNING=False

$HOME/.local/bin/ansible-playbook -K "$playbook"
if test $? -eq 0; then
    info setup complete
else
    fail ansible failed
fi

if test -f $HOME/.bashrc; then
    . $HOME/.bashrc
fi
