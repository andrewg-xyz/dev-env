#!/bin/bash

if [[ $(uname) != "Linux" ]]; then
    echo "Unsupported operating system"
    exit 1
fi

script_path="$(
    cd "$(dirname "$0")"
    pwd -P
)"
sudo apt-get install build-essential procps curl file git zsh -y
chsh -s $(which zsh)

echo "FOR ZSH TO TAKE EFFECT, LOGOUT AND LOG BACK IN"
