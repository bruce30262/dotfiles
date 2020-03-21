# source the default .bashrc from Ubuntu Linux 14.04.3
source $HOME/dotfiles/bash/.bashrc.ori;

# source all the files in rcS/ dir
for file in $HOME/dotfiles/rcS/*;
do
    source "$file"
done

# source .bashrc.local for local bash setting (if the file exists)
[ -f ~/.bashrc.local ] && source ~/.bashrc.local
