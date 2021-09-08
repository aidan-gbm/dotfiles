#!/usr/bin/env bash

# Argument is current path of dotfiles directory
cp $1/bashrc $HOME/.bashrc
cp $1/tmux.conf $HOME/.tmux.conf
cp $1/vimrc $HOME/.vimrc
source $HOME/.bashrc
