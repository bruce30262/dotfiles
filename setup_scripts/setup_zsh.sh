#!/usr/bin/env bash

# Should run stow before running this script

set -ex

sudo apt update

# Install dependencies ( zsh, curl )
sudo apt install -y zsh curl

# Install zimfw
curl -fLo ~/.config/zsh/.zim/zimfw.zsh --create-dirs \
  https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
chmod +x ~/.config/zsh/.zim/zimfw.zsh
zsh -c "source ~/.config/zsh/.zim/zimfw.zsh install"

