cur_dir=$(dirname $(readlink -f $BASH_SOURCE))

# source the default .bashrc from Ubuntu Linux 14.04.3
source ~/dotfiles/bash/.bashrc.ori

# source all the .alias file in the aliases/ dir
for file in $cur_dir/../aliases/{,.}*.alias;
do
    source "$file"
done
