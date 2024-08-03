#!/usr/bin/env bash

# Setup python environment, including basically uv
# Should run stow before running this script

set -ex

sudo nala update

# Install dependencies ( curl, python3 )
sudo nala install -y curl python3

# Install uv
curl -LsSf https://astral.sh/uv/install.sh | sh
. "$HOME/.cargo/env"

# Setup default venv
uv venv
