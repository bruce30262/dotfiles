#!/bin/bash

usage() {
    set +x
    echo "Usage: (-h/--help|--fzf|--rg|--fd|--btop)"
}

# https://gist.github.com/lukechilds/a83e1d7127b78fef38c2914c4ececc3c
get_latest_release() {
    curl --silent "https://api.github.com/repos/$1/releases/latest" | # Get latest release from GitHub api
        grep '"tag_name":' |                                          # Get tag line
        sed -E 's/.*"([^"]+)".*/\1/'                                  # Pluck JSON value
}

download_release() { # REPO, VERSION, FILENAME
    wget https://github.com/$1/releases/download/$2/$3
}

dpkg_install() { # FILENAME
    sudo dpkg -i $1
}

download_and_dpkg_install() { # REPO, VERSION, FILENAME
    download_release $1 $2 $3
    dpkg_install $3
    rm $3
    echo "Done installing. To uninstall use the apt/nala command as usual."
}

install_fzf() {
    set -x
    # Remove it first if exist
    if [ -f /usr/bin/fzf ]; then
        sudo rm -f /usr/bin/fzf
    fi
    # Download repo and bin
    git clone https://github.com/junegunn/fzf
    fzf/install --bin
    # Install
    sudo cp fzf/bin/fzf /usr/bin/
    mkdir -p $HOME/.config/fzf/
    cp fzf/shell/* $HOME/.config/fzf/
    rm -rf ./fzf

    set +x
    echo "Done installing. To uninstall delete /usr/bin/fzf with sudo, and remove $HOME/.config/fzf/ directory."
}

install_ripgrep() {
    REPO=BurntSushi/ripgrep
    VERSION=$(get_latest_release $REPO)
    FILENAME=ripgrep_$VERSION-1_amd64.deb
    download_and_dpkg_install $REPO $VERSION $FILENAME
}

install_fd() {
    REPO=sharkdp/fd
    VERSION=$(get_latest_release $REPO)
    FILENAME=fd_${VERSION:1}_amd64.deb
    download_and_dpkg_install $REPO $VERSION $FILENAME
}

install_btop() {
    REPO=aristocratos/btop
    VERSION=$(get_latest_release $REPO)
    FILENAME=btop-x86_64-linux-musl.tbz
    # Download latest release
    rm -rf $FILENAME btop
    download_release $REPO $VERSION $FILENAME
    # Install
    tar xf $FILENAME
    pushd btop
    ./uninstall.sh # uninstall first
    ./install.sh
    popd
    # Clean up
    rm -rf $FILENAME btop
}

if (( $# == 0 ))
then
    usage
    exit 1
fi

set -e

while (( $# > 0 ))
do
    opt="$1"
    shift
    case $opt in
        -h|--help)
            usage
            exit 0
            ;;
        --fzf)
            install_fzf
            ;;
        --rg)
            install_ripgrep
            ;;
        --fd)
            install_fd
            ;;
        --btop)
            install_btop
            ;;
        *) # default
            usage
            exit 1
            ;;
    esac
done

set +x
echo "All done."
