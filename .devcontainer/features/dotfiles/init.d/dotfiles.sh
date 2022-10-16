#!/usr/bin/with-contenv bash
# shellcheck shell=bash

set -eux

if [ -z "$DOTFILES_TARGET_PATH" ]; then
    echo "DOTFILES_TARGET_PATH is not set. Skip installing."
    exit 0
fi

if [ ! -d "$DOTFILES_TARGET_PATH" ]; then
    echo "\"$DOTFILES_TARGET_PATH\" is not a directory. Skip installing."
    exit 0
fi

cd "$DOTFILES_TARGET_PATH"
if [ -z "$DOTFILES_INSTALL_COMMAND" ]; then
    if [ -f "install.sh" ] && [ -x "install.sh" ]; then
        su -c "./install.sh" rstudio
        exit 0
    fi
    if [ -f "install" ] && [ -x "install.sh" ]; then
        su -c "./install" rstudio
        exit 0
    fi
    echo "Dotfiles install command was not found. Skip installing."
else
    set +e
    su -c "$(printf '%q' "$DOTFILES_INSTALL_COMMAND")" rstudio
    set -e
fi
