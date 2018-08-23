#!/bin/bash

# script to install YaHei-Consolas-Hybrid & Monaco fonts

CUR_DIR="$(dirname "$(readlink -f "$0")")"

set -e

if [ ! $(command -v wget) ]; then
    echo "please install wget"
    exit 0
elif [ $UID -ne 0 ]; then
    echo "You need to use root."
    exit 0
else

echo 'Truetype folder Creating...'
echo 'path:/usr/share/fonts/truetype/YaHei\ Consolas\ Hybrid'
echo 'path:/usr/share/fonts/truetype/Monaco'

mkdir -p /usr/share/fonts/truetype/YaHei\ Consolas\ Hybrid
mkdir -p /usr/share/fonts/truetype/Monaco

echo 'Copy fonts to truetype folder...'

cp $CUR_DIR/YaHei\ Consolas\ Hybrid\ 1.12.ttf /usr/share/fonts/truetype/YaHei\ Consolas\ Hybrid
cp $CUR_DIR/Monaco.ttf /usr/share/fonts/truetype/Monaco

echo 'Modifying font permissions...'

chmod 644 /usr/share/fonts/truetype/YaHei\ Consolas\ Hybrid/YaHei\ Consolas\ Hybrid\ 1.12.ttf
chmod 644 /usr/share/fonts/truetype/Monaco/Monaco.ttf

echo 'installing fonts...'

fc-cache -fv

echo 'Complete!'

fi
