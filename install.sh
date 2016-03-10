#!/bin/sh 

cur_path=$(dirname $0)

# install vim
echo "installing vim..."
sudo apt-get install -y vim
echo "setting vim..."
sh $cur_path/set_vim.sh
echo "done setting vim."

# install ruby
echo "installing ruby..."
sudo apt-get install -y ruby

# run the other setup via a ruby script
echo "running setup ruby script..."
ruby $cur_path/install.rb

echo "All done!"
