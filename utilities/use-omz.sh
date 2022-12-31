#!/bin/bash
if [ ! -f /usr/bin/zsh ]
then
    echo "zsh does not exist."
    apt update
    # Install zsh and less, because zsh is used by oh-my-zsh and less is used by git
    apt install zsh less -y
    chsh -s $(which zsh)
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    /usr/bin/zsh
else
    echo "zsh found, going to run it."
    /usr/bin/zsh
fi
