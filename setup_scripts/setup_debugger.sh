#!/usr/bin/env bash

# Should run stow before running this script

DBGDIR=~/.config/gdb
ZDOTDIR=~/.config/zsh

usage() {
    set +x
    echo "Usage: (-h/--help|--peda|--pwndbg|--gef)"
}

setup_angelheap() {
    if [ ! -d $DBGDIR/Pwngdb ]
    then
        git clone https://github.com/scwuaptx/Pwngdb.git $DBGDIR/Pwngdb
    fi
}

setup_peda() {
    setup_angelheap
    if [ ! -d $DBGDIR/peda ] 
    then
        git clone https://github.com/bruce30262/peda.git $DBGDIR/peda
    fi
}

setup_pwndbg() {
    setup_angelheap
    if [ ! -d $DBGDIR/pwndbg ]
    then
        git clone https://github.com/pwndbg/pwndbg $DBGDIR/pwndbg
        pushd $DBGDIR/pwndbg
        sudo ./setup.sh
        popd
    fi
}

setup_gef() {
    setup_angelheap
    # Always install the latest version
    wget -O $DBGDIR/.gdbinit-gef.py https://raw.githubusercontent.com/hugsy/gef/main/gef.py
}

if (( $# == 0 ))
then
    usage
    exit 1
fi

set -ex

while (( $# > 0 ))
do
    opt="$1"
    shift
    case $opt in
        -h|--help)
            usage
            exit 0
            ;;
        --peda)
            setup_peda
            ;;
        --pwndbg)
            setup_pwndbg
            ;;
        --gef)
            setup_gef
            ;;
        *) # default
            usage
            exit 1
            ;;
    esac
done

# If we're here, means debugger has been set. Copy alias to rcS folder
cp ~/dotfiles/.config/gdb/dbg.alias $ZDOTDIR/rcS

set +x
echo "Done."
echo "source .zshrc to apply the latest debugger settings."
