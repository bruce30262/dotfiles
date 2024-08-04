# copy this file into ~/.bash_aliases for bash aliases
alias sni="sudo nala install"
alias up="sudo nala upgrade --update --full --autoremove --purge && sudo nala clean"
alias llh="ll -h"
alias llrt="ll -rt"
alias mps="ps -eo pid,cmd,etime"
alias mpsg="ps -eo pid,cmd,etime | grep"
alias duso="du -sh * | sort -rh | head -n "
alias dus="du -sh"
alias dfh="df -h"

# Add /sbin in $PATH if it doesn't exist in $PATH
if ! [[ ":$PATH:" == *":/sbin:"* ]] && [ -d "/sbin" ]; then
    export PATH=$PATH:/sbin
fi

# tmux
alias tmux="tmux -2" 

# uv
if command -v uv &> /dev/null
then
    alias py="source ~/.venv/bin/activate"
    alias depy="deactivcate"
fi

# nvim
if command -v nvim &> /dev/null
then
    alias vim="nvim"
fi
