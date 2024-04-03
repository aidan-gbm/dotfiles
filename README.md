# dotfiles

Ansible playbook(s) for setting up dotfiles.

## Install

Requirements

- Python3 w/ venv
- rsync

```sh
# venv for ansible
python3 -m venv venv
. venv/bin/activate

pip install ansible
ansible-playbook development.yml
```
