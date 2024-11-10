#!/usr/bin/env bash

# Should run stow before running this script

TPM_PATH=~/.config/tmux/plugins/tpm 

set -ex

sudo nala update

# Install dependencies ( tmux )
sudo nala install -y tmux

# Install tpm if tpm does not exists
[ ! -d $TPM_PATH ] && git clone https://github.com/tmux-plugins/tpm $TPM_PATH

set +x
echo "Done !"
echo "In tmux, use <prefix> + I to install tmux plugins."
