#!/bin/bash 

# this script will install some tools that I found necessary

set -ex

cur_dir=$(dirname $(readlink -f $BASH_SOURCE))

# update package info
sudo apt-get -y update

# install & set vim
echo "installing vim..."
sudo apt-get install -y vim
echo "setting vim..."
bash $cur_dir/set_vim.sh
echo "done setting vim."

# install gdb, gcc
sudo apt-get install -y gcc gdb

# other tools
sudo apt-get install -y python3 python-is-python3
sudo apt-get install -y htop
sudo apt-get install -y ruby
sudo apt-get install -y tig
sudo apt-get install -y openssh-server 
sudo apt-get install -y python3-pip
sudo apt-get install -y netcat
sudo apt-get install -y net-tools
sudo apt-get install -y curl

echo "All done!"
echo "Run ./install.rb -h for further configuration"
