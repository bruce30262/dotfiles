#!/usr/bin/env bash

# Simple wrapper script for generating ed25519 ssh key

ssh-keygen -t ed25519 "$@"
