#!/usr/bin/env bash

# Can be run as a single script to install neovim settings

set -ex

sudo apt update

# Install dependencies ( neovim, stow, curl )
echo "Installing dependencies..."
sudo apt install -y neovim stow curl

# Install vim-plug
echo "Installing vim-plug..."
curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Install vim settings
cd ~/dotfiles/.config && stow -t ~/.config/nvim/ nvim
nvim -es -u ~/.config/nvim/init.vim -i NONE -c "PlugInstall" -c "qa"
