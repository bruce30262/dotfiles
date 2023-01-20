#!/usr/bin/env bash

# Should run stow before running this script

set -ex

sudo apt update

# Install dependencies ( zsh, curl )
echo "Installing dependencies..."
sudo apt install -y zsh curl

# Install zimfw
echo "Installing zimfw..."
curl -fLo ~/.config/zsh/.zim/zimfw.sh --create-dirs \
  https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
chmod +x ~/.config/zsh/.zim/zimfw.sh
zsh -c "source ~/.config/zsh/.zim/zimfw.sh install"

