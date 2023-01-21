#!/usr/bin/env bash

# Should run stow before running this script

set -ex

sudo apt update

# Install dependencies ( neovim, curl )
echo "Installing dependencies..."
sudo apt install -y neovim curl

# Install vim-plug
echo "Installing vim-plug..."
curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Install vim settings
echo "Installing nvim plugins..."
nvim -es -u ~/.config/nvim/init.vim -i NONE -c "PlugInstall" -c "qa"

# Setup alias
echo "Setting nvim aliases..."
cp ~/dotfiles/.config/nvim/nvim.alias ~/dotfiles/rcS

