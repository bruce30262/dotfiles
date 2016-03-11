cur_dir=$(dirname $(readlink -f $BASH_SOURCE))

# source the default .bashrc from Ubuntu Linux 14.04.3
source $cur_dir/.bashrc.ori

# source all the .alias file in the aliases/ dir
for file in $cur_dir/../aliases/{,.}*.alias;
do
    source "$file"
done

# source .bashrc.local for local bash setting (if the file exists)
[ -f ~/.bashrc.local ] && source ~/.bashrc.local
