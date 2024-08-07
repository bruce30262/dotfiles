#!/usr/bin/env bash

# Should run stow before running this script

set -ex

sudo nala update

# Install dependencies ( neovim, curl )
sudo nala install -y neovim curl

# Install vim-plug
curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Install vim settings
set +e # disable -e because the followings will return 1 even if all plugins have installed successfully
nvim -es -u ~/.config/nvim/init.vim -i NONE -c "PlugInstall" -c "qa"

# Setup alias
set -e
ZDOTDIR=~/.config/zsh
cp ~/dotfiles/.config/nvim/nvim.alias $ZDOTDIR/rcS

