cur_dir=$(dirname $(readlink -f ~/.zshrc))

# source my own .zshrc 
source $cur_dir/.zshrc.ori

# source all the .alias file in the aliases/ dir
for file in $cur_dir/../aliases/*.alias;
do
    source "$file"
done

