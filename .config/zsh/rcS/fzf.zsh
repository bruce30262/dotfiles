FZF_RC_DIR=$HOME/.config/fzf

# Use fd (https://github.com/sharkdp/fd) for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
_fzf_compgen_path() {
    fd --hidden --follow --exclude ".git" . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
    fd --type d --hidden --follow --exclude ".git" . "$1"
}

# Bind home and end to pgup/pgdown in preview panel
PREVIEW_PGUD="home:preview-page-up,end:preview-page-down"

# Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
    local command=$1
    shift

    case "$command" in
        cd)           fzf --preview 'tree -C {} | head -200' --bind $PREVIEW_PGUD "$@" ;;
        ssh)          fzf --preview 'dig {}'  --bind $PREVIEW_PGUD "$@" ;;
        vim)          fzf --preview 'less {}' --bind $PREVIEW_PGUD "$@" ;;
    esac
}

if [ -x "$(command -v fzf)"  ]
then
    # If we're in here, we assume fzf, ripgrep & fd are all installed
    # https://github.com/junegunn/fzf/issues/634#issuecomment-1008200731
    export FZF_DEFAULT_COMMAND="rg --files --follow --no-ignore-vcs --hidden -g '!{**/.git/*}'"
    # Set style for file list and preview panel
    export FZF_COMPLETION_OPTS='--border --info=inline' 
    source $FZF_RC_DIR/key-bindings.zsh
    source $FZF_RC_DIR/completion.zsh
    # https://www.youtube.com/watch?v=aLMepxvUj4s
    alias pf="fzf --preview='less {}' --bind $PREVIEW_PGUD"
else
    echo "Install fzf first."
fi
