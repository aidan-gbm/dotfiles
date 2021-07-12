# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# History File Settings 
HISTSIZE=1000
HISTFILESIZE=1000
HISTCONTROL=ignoreboth
shopt -s histappend

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Identify the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# Set a fancy prompt
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

## Formatting
red="\[\033[31m\]"
blue="\[\033[96m\]"
gray="\[\033[37m\]"
green="\[\033[92m\]"
reset="\[\033[0m\]"

ipi () { ip a show $1 ; }

## Sections
sec_start="$red┌──"
sec_connect="$red─"
sec_status="\$([ \$? != 0 ] && echo \"$red[✗]\")"
[ ${EUID} == 0 ] && \
    sec_user="$red[\u$gray@$blue\h$red]" || \
    sec_user="$red[$blue\u$gray@$blue\h$red]"
sec_tun0="\$(ipi | grep -q tun0 && echo -n \"[$green\" && ip -f inet -o addr show tun0 | awk '{print \$4}' | cut -d / -f1 | tr -d '\n' && echo -n \"$red]$sec_connect\")"
sec_dir="$red[$green\w$red]"
sec_end="$red└──╼ $gray\$ $reset" 

if [ "$color_prompt" = yes ]; then
    PS1="$sec_start$sec_status$sec_connect$sec_user$sec_connect$sec_tun0$sec_dir\n$sec_end"
else
    PS1='┌──[\u@\h]─[\w]\n└──╼ \$ '
fi
unset color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# Enable Colors for Commands
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias grep='grep --color=auto'
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Alias definitions.
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

