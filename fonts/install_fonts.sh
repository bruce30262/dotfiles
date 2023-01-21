#!/usr/bin/env bash

if [ "$EUID" -ne 0 ]
then
    echo "Use sudo to run this script"
    exit 1
fi

set -ex

CUR_DIR=$(dirname "$0")
TRUETYPE_DIR=/usr/share/fonts/truetype

for file in "$CUR_DIR"/*tf; do
      # get filename without extension
      # e.g. "dotfiles/fonts/Consolas Nerd Font Complete Mono Windows Compatible.ttf" ->
      # "Consolas Nerd Font Complete Mono Windows Compatible"
      # ref: https://stackoverflow.com/questions/965053/extract-filename-and-extension-in-bash
      # ref: https://myapollo.com.tw/zh-tw/bash-parameter-expansion/
      fn="${file##*/}" # delete longest prefix before '/'
      fn_prefix="${fn%.*}" # delete shortest suffix after '.'
      FONT_DIR=$TRUETYPE_DIR/$fn_prefix
      mkdir -p "$FONT_DIR"
      cp "$file" "$FONT_DIR"
      chmod 644 "$FONT_DIR/$fn"
done

fc-cache -fv

set +x
echo "Done !"
