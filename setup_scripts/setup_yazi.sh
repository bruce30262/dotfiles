#!/bin/sh

set -ex

# Install yazi
curl -fsSL https://yazi-rs.github.io/builds/yazi-keyring.gpg | sudo tee /usr/share/keyrings/yazi-keyring.gpg >/dev/null
echo 'deb [signed-by=/usr/share/keyrings/yazi-keyring.gpg] https://yazi-rs.github.io/builds/ stable main' | sudo tee /etc/apt/sources.list.d/yazi.list >/dev/null
sudo apt update && sudo apt install -y yazi

CONFIG_DIR=$HOME/.config/yazi
# Setup theme
wget -O $CONFIG_DIR/theme.toml https://raw.githubusercontent.com/catppuccin/yazi/refs/heads/main/themes/mocha/catppuccin-mocha-blue.toml

# Install plugin
ya pkg add yazi-rs/plugins:smart-enter
ya pkg add masaki39/fd-fzf

# Setup rc for zsh
set -e
ZDOTDIR=~/.config/zsh
ln -sf ~/dotfiles/.config/yazi/yazi.rc $ZDOTDIR/rcS
rm $CONFIG_DIR/yazi.rc # remove the one created by stow

