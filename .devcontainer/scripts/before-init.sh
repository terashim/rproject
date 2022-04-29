#!/bin/bash

set -eux

if [ -S $SSH_AUTH_SOCK ]; then
    chmod go+w $SSH_AUTH_SOCK
fi

DOTFILES_DIR_CONTAINER=${DOTFILES_DIR_CONTAINER:-/home/rstudio/.dotfiles}
DOTFILES_INSTALL_SCRIPT=${DOTFILES_INSTALL_SCRIPT:-$DOTFILES_DIR_CONTAINER/install.sh}
if [ -f $DOTFILES_INSTALL_SCRIPT ]; then
    su -c "bash $DOTFILES_INSTALL_SCRIPT" rstudio
fi
