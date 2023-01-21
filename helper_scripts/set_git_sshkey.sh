#!/usr/bin/env bash

set -ex

CUR_DIR=$(dirname "$0")

DEFAULT_EMAIL="bruce30262@pm.me"
DEFAULT_KEY_FILE=~/.ssh/ida_rsa

$CUR_DIR/gen_sshkey.sh -C $DEFAULT_EMAIL -f $DEFAULT_KEY_FILE
ssh-add $DEFAULT_KEY_FILE

