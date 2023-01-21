#!/usr/bin/env bash

# Simple wrapper script for generating rsa 4096 ssh key

ssh-keygen -t rsa -b 4096 "$@"
