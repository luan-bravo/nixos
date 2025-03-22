#!/bin/sh

usage() {
    echo "Usage: switch HOST [USER]"
    echo "USER: the '/home/USER/' will get a symlink of 'home.nix' at '.config/home-manager/'"
}

if [ $# -st 1 ]; then
    echo "Error: Missing arguments"
    usage()
    exit 1
elif [ $# -st 2 ]; then
    echo "Error: Too many arguments"
    usage()
    exit 1
elif [ ! -d /home/$2 ]; then
    echo "Error: No such user"
    usage()
    exit 1
fi

nixos-rebuild switch --flake /etc/nixos#$1 && {
    home=/home/$2
    { [ ! -d $home/.config/home-manager ] && mkdir -p $home/.config } || exit 1
    chown $2 /etc/nixos/hosts/$1
    ln -sf /etc/nixos/hosts/$1 $home/.config/home-manager/home.nix
}
