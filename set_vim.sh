#!/usr/bin/env bash
# Install vim and make sure it has python3 support
sudo apt-get install -y vim vim-nox
# Install powerline and font
sudo apt-get install -y powerline fonts-powerline
# Install my vim settings
mkdir -p ~/.vim 
git clone --recurse-submodules https://github.com/bruce30262/vim ~/.vim
ln -sf ~/.vim/.vimrc ~/.vimrc
