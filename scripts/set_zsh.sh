#!/usr/bin/env bash
set -ex

# Can be run as a single script to install zsh settings

sudo apt update

# Install dependencies ( zsh, stow, curl )
echo "Installing dependencies..."
sudo apt install -y zsh stow curl

# Link zsh configs
mkdir -p ~/.config/zsh
cd ~/dotfiles/.config && stow -t ~/.config/zsh/ zsh

# Install zimfw
echo "Installing zimfw..."
curl -fLo ~/.config/zsh/.zim/zimfw.sh --create-dirs \
  https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
chmod +x ~/.config/zsh/.zim/zimfw.sh
zsh -c "source ~/.config/zsh/.zim/zimfw.sh install"

