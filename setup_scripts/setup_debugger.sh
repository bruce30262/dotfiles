#!/usr/bin/env bash

DBGDIR=~/.config/gdb

usage() {
    echo "Usage: (-h/--help|--peda|--pwndbg|--gef)"
}

setup_angelheap() {
    [ ! -d $DBGDIR/Pwngdb ] && echo "Installing angelheap..." && git clone https://github.com/scwuaptx/Pwngdb.git $DBGDIR/Pwngdb
}

setup_peda() {
    setup_angelheap
    [ ! -d $DBGDIR/peda ] && echo "Installing peda..." && git clone https://github.com/bruce30262/peda.git $DBGDIR/peda
}

setup_pwndbg() {
    setup_angelheap
    [ ! -d $DBGDIR/pwndbg ] && echo "Installing pwndbg..." && git clone https://github.com/pwndbg/pwndbg $DBGDIR/pwndbg &&\
        cd $DBGDIR/pwndbg && sudo ./setup.sh
}

setup_gef() {
    setup_angelheap
    # Always install the latest version
    wget -O $DBGDIR/.gdbinit-gef.py https://raw.githubusercontent.com/hugsy/gef/dev/gef.py
}

if (( $# == 0 ))
then
    usage
    exit 1
fi

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
echo "Setting alias..."
cp ~/dotfiles/.config/gdb/dbg.alias ~/dotfiles/rcS
echo "Done."
echo "source .zshrc to apply the latest debugger settings."
