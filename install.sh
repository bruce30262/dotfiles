#!/bin/bash 

# this script install the whole environment settings

cur_dir=$(dirname $(readlink -f $BASH_SOURCE))

# update package info
sudo apt-get -y update

# install & set vim
echo "installing vim..."
sudo apt-get install -y vim
echo "setting vim..."
bash $cur_dir/set_vim.sh
echo "done setting vim."

# install nasm, gdb, gcc & g++ family
sudo apt-get install -y nasm
sudo apt-get install -y gcc g++
sudo apt-get install -y gcc-multilib g++-multilib
sudo apt-get install -y gdb gdb-multiarch

# other tools
sudo apt-get install -y python
sudo apt-get install -y htop
sudo apt-get install -y ruby
sudo apt-get install -y tig
sudo apt-get install -y openssh-server 
sudo apt-get install -y python-pip
sudo apt-get install -y nmap
sudo apt-get install -y net-tools
sudo apt-get install -y curl

echo "All done!"
echo "Run ./install.rb -h for further configuration"
