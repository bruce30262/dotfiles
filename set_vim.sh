#!/usr/bin/env sh

cd ~/ && mkdir -p ~/.vim && cd ~/.vim 
git clone https://github.com/bruce30262/vim . 
git submodule update --init # update submodule
git submodule update --remote --merge
ln -s ~/.vim/.vimrc ~/.vimrc
