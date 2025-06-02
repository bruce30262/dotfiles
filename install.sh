#!/bin/bash 

# Install tools that I found necessary
# Stow dotfiles
# Setup nvim, zsh & tmux

set -ex

# update package info
sudo apt -y update

# install nala
sudo apt install -y nala

# install necessary tools
sudo nala upgrade --full
sudo nala install -y stow \
    gcc gdb make\
    python3 python-is-python3 \
    openssh-server \
    net-tools \
    tig \
    curl wget

# stow dotfiles
stow -t ~ --no-folding .

# setup env
pushd setup_scripts
./setup_non_apt_package.sh --fzf --rg --fd --btop
./setup_zsh.sh
./setup_nvim.sh
./setup_tmux.sh
./setup_python.sh
popd

set +x
echo "All done !"

