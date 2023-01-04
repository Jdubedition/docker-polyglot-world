#!/bin/bash
if [ ! -f /usr/bin/zsh ]
then
    # Used for Python, Go, Nodejs, Rust, Crystal
    echo "zsh does not exist."
    apt update
    # Install zsh and less, because zsh is used by oh-my-zsh and less is used by git
    apt install zsh less curl git -y
    chsh -s $(which zsh)
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    /usr/bin/zsh
else
    # Used for Deno
    echo "zsh found, going to install other dependencies and run it."
    apt update
    apt install curl git -y
    chsh -s $(which zsh)
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    /usr/bin/zsh
fi
