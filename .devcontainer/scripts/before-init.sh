#!/bin/bash

set -eux

SSH_AUTH_SOCK=${SSH_AUTH_SOCK:-/dev/null}
if [ -S $SSH_AUTH_SOCK ]; then
    chmod go+w $SSH_AUTH_SOCK
fi

DOTFILES_INSTALL_COMMAND=${DOTFILES_INSTALL_COMMAND:-"bash /mnt/dotfiles/install.sh"}
if [ -n "$DOTFILES_INSTALL_COMMAND" ]; then
    su -c "$DOTFILES_INSTALL_COMMAND" rstudio
fi
