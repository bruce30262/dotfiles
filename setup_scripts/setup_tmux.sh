#!/usr/bin/env bash

# Should run stow before running this script

set -ex

sudo nala update

# Install dependencies ( tmux )
sudo nala install -y tmux

# Install tpm if tpm does not exists
[ ! -d ~/.tmux/plugins/tpm ] && git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

set +x
echo "Done !"
echo "In tmux, use <prefix> + I to install tmux plugins."
