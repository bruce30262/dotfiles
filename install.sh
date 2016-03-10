#!/bin/sh 

# install vim
echo "installing vim..."
sudo apt-get install -y vim

# configure my vim
echo "setting vim..."
cd ~/ && mkdir -p ~/.vim && cd ~/.vim 
git clone https://github.com/bruce30262/vim . 
git submodule update --init # update submodule
git submodule update --remote --merge
ln -s ~/.vim/.vimrc ~/.vimrc

# install ruby
echo "installing ruby..."
sudo apt-get install -y ruby

# run the other setup via a ruby script
ruby ~/dotfiles/install.rb

echo "All done!"
