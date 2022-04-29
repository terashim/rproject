#!/bin/bash

set -eux

DOTFILES_ROOT=$(dirname $(readlink -f $0))
cd $DOTFILES_ROOT

XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
mkdir -p $XDG_CONFIG_HOME
ln -sfnv $DOTFILES_ROOT/.config/git $XDG_CONFIG_HOME/git
ln -sfnv $DOTFILES_ROOT/.config/rstudio $XDG_CONFIG_HOME/rstudio
