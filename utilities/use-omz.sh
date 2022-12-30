#!/bin/bash
if [ ! -f /usr/bin/zsh ]
then
    echo "zsh does not exist."
    apt update
    apt install zsh -y
    chsh -s $(which zsh)
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    /usr/bin/zsh
else
    echo "zsh found, going to run it."
    /usr/bin/zsh
fi
