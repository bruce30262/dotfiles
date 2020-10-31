#!/usr/bin/env bash
# Install vim and make sure it has python3 support
sudo apt-get install -y vim vim-nox
# Install powerline and font
sudo apt-get install -y powerline fonts-powerline
# Install my vim settings
cd ~/ && mkdir -p ~/.vim && cd ~/.vim 
git clone https://github.com/bruce30262/vim . 
git submodule update --init # update submodule
git submodule update --remote --merge
ln -sf ~/.vim/.vimrc ~/.vimrc
