#!/bin/bash

# use qemu-static-user to emulate arm enviroment
# will install gcc & g++ toolchain, libc & libstdc++
# download armtool.alias from https://github.com/bruce30262/CTF
# works on Ubuntu 16.04.1

cur_dir=$(dirname $(readlink -f $BASH_SOURCE))

# qemu-arm-static
sudo apt-get install -y qemu-user-static &&\
# arm (gcc & libc)
sudo apt-get install -y gcc-arm-linux-gnueabihf libc6-dev-armhf-cross &&\
# aarch64 (gcc & libc)
sudo apt-get install -y gcc-aarch64-linux-gnu libc6-dev-arm64-cross &&\
# arm (g++ & libstdc++)
sudo apt-get install -y g++-arm-linux-gnueabihf libstdc++-5-dev-armhf-cross &&\
# aarch64 (g++ & libstdc++)
sudo apt-get install -y g++-aarch64-linux-gnu libstdc++-5-dev-arm64-cross &&\

# binfmt
sudo apt-get install 'binfmt*'

echo "setting alias..."
curl -fsSL https://raw.githubusercontent.com/bruce30262/CTF/master/script/armtool.alias -o $cur_dir/aliases/arm-toolchain.alias
echo "source ~/.zshrc to apply the latest arm-toolchain setting"
