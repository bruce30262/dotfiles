#!/usr/bin/env bash

# Usage: EMAIL="<email>" KEY_FILE="<key_file>" ./set_git_sshkey.sh
# If EMAIL or KEY_FILE isn't set in command line, it will just use the default one
# The encryption is ed25519

set -ex

CUR_DIR=$(dirname "$0")

EMAIL="${EMAIL:=bruce30262@pm.me}"
KEY_FILE=${KEY_FILE:=~/.ssh/id_ed25519}

$CUR_DIR/gen_sshkey.sh -C $EMAIL -f $KEY_FILE
eval "$(ssh-agent -s)"
ssh-add $KEY_FILE

