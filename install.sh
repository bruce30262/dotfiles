#!/bin/bash 

# this script install the whole environment settings

cur_dir=$(dirname $(readlink -f $BASH_SOURCE))

# update package info
sudo apt-get -y update

# install vim
echo "installing vim..."
sudo apt-get install -y vim
echo "setting vim..."
bash $cur_dir/set_vim.sh
echo "done setting vim."

# install curl
echo "installing curl..."
sudo apt-get install -y curl

# install nasm, gdb, gcc & g++ family
sudo apt-get install -y nasm
sudo apt-get install -y gcc g++
sudo apt-get install -y gcc-multilib g++-multilib
sudo apt-get install -y gdb gdb-multiarch

# other tools
sudo apt-get install -y openssh-server 
sudo apt-get install -y python-pip python-pip3
sudo apt-get install -y nmap

# install ruby
echo "installing ruby..."
sudo apt-get install -y ruby

# run the other setup via a ruby script
echo "running setup ruby script..."
ruby $cur_dir/install.rb --all

echo "All done!"
echo "Log out & login to load the latest zsh setting."
