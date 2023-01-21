#!/usr/bin/env bash

# Should run stow before running this script

set -ex

sudo apt update

# Install dependencies ( tmux )
sudo apt install -y tmux

# Install tpm if tpm does not exists
[ ! -d ~/.tmux/plugins/tpm ] && git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

set +x
echo "Done !"
echo "In tmux, use <prefix> + I to install tmux plugins."
