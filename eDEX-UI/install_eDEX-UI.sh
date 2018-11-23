#!/bin/bash

# apply customize settings to eDEX-UI
# https://github.com/GitSquared/edex-ui

set -e

cur_dir=$(dirname $(readlink -f $BASH_SOURCE))

cp $cur_dir/themes/*.json ~/.config/eDEX-UI/themes/
cp $cur_dir/fonts/*.woff2 ~/.config/eDEX-UI/fonts/
cp $cur_dir/settings.json ~/.config/eDEX-UI/
