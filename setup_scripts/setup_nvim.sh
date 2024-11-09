#!/usr/bin/env bash

# Should run stow before running this script

set -ex

sudo nala update

# Install dependencies ( wget )
sudo nala install -y wget

# Install neovim from latest github release
if [ -d /opt/nvim-linux64 ]; then
    sudo rm -rf /opt/nvim-linux64
fi
wget https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
sudo tar xf nvim-linux64.tar.gz -C /opt/
sudo ln -snf /opt/nvim-linux64/bin/nvim /usr/bin/nvim
rm nvim-linux64.tar.gz

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

