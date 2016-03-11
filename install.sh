#!/bin/bash 

cur_dir=$(dirname $(readlink -f $BASH_SOURCE))

# install vim
echo "installing vim..."
sudo apt-get install -y vim
echo "setting vim..."
bash $cur_dir/set_vim.sh
echo "done setting vim."

# install ruby
echo "installing ruby..."
sudo apt-get install -y ruby

# run the other setup via a ruby script
echo "running setup ruby script..."
ruby $cur_dir/install.rb --all

echo "All done!"
echo "source ~/.bashrc to load the latest bashrc setting."
