#!/usr/bin/env sh

info() {
    echo "[+] $*"
}

fail() {
    echo "[-] $*"
    exit 1
}

VENV="$HOME/.local/venv"

if test -d "$VENV"; then
    system=$(sed -nr 's/.*-site-packages = (\w+)/\1/p' "$VENV/pyvenv.cfg")
    if test "$system" = "true"; then
        info "using existing virtual environment"
    else
        fail "existing environment does not include system site packages"
    fi
else
    info "creating virtual environment"
    python3 -m venv --system-site-packages "$VENV"
fi

. "$VENV/bin/activate"

info "installing ansible"
pip install -qq --user ansible

REPO=$(dirname -- "$0")
if ! test -f "$REPO/development.yml"; then
    fail "cannot locate playbook"
fi

ansible-playbook -K "$REPO/development.yml"

if test $? -eq 0; then
    info "complete"
else
    fail "ansible failed"
fi
