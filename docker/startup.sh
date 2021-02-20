#!/bin/bash

set -ux

DOTFILES_INSTALL_SCRIPT=${DOTFILES_INSTALL_SCRIPT:-/home/rstudio/dotfiles/install.sh}

if [ -f $DOTFILES_INSTALL_SCRIPT ]; then
    bash $DOTFILES_INSTALL_SCRIPT
fi

/init
