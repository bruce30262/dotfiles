#!/bin/bash 

# Install tools that I found necessary
# Stow dotfiles
# Setup nvim, zsh & tmux

set -ex

# update package info
sudo apt-get -y update

# install necessary tools
sudo apt-get install -y stow \
    gcc gdb \
    python3 python-is-python3 python3-pip \
    openssh-server \
    netcat net-tools \
    htop \
    tig \
    curl

# stow dotfiles
stow -t ~ --no-folding .

# setup env
pushd setup_scripts
./setup_nvim.sh
./setup_zsh.sh
./setup_tmux.sh
popd

set +x
echo "All done !"

