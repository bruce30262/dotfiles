FZF_RC_DIR=$HOME/.config/fzf

if [ -x "$(command -v fzf)"  ]
then
    # If we're in here, we assume fzf, ripgrep & fd-find are all installed
    # https://github.com/junegunn/fzf/issues/634#issuecomment-1008200731
    export FZF_DEFAULT_COMMAND="rg --files --follow --no-ignore-vcs --hidden -g '!{**/.git/*}'"
    source $FZF_RC_DIR/key-bindings.zsh
    source $FZF_RC_DIR/completion.zsh
    # https://www.youtube.com/watch?v=aLMepxvUj4s
    alias pf="fzf --preview='less {}' --bind shift-up:preview-page-up,shift-down:preview-page-down"
    alias cdf='cd $(fd --type d --hidden | fzf)'
    alias vimf='vim $(fzf)'
else
    echo "Install fzf first."
fi
