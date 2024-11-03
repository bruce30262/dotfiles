#!/bin/bash

set -e

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
    git clone https://github.com/junegunn/fzf
    fzf/install --bin
    sudo install -v fzf/bin/fzf /bin
    sudo install -v fzf/bin/fzf /usr/bin
    mkdir -p $HOME/.config/fzf/
    cp fzf/shell/* $HOME/.config/fzf/
    rm -rf ./fzf
    set +x
    echo "Done installing. To uninstall delete the file in /bin and /usr/bin with sudo, and remove $HOME/.config/fzf/ directory."
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

install_fzf
install_ripgrep
install_fd

