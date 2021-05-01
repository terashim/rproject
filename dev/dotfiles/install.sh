#!/bin/bash

set -eux

DOTFILES_ROOT=$(dirname $(readlink -f $0))
cd $DOTFILES_ROOT

sudo -u rstudio mkdir -p /home/rstudio/.config
sudo -u rstudio ln -sfnv $DOTFILES_ROOT/.config/rstudio /home/rstudio/.config/rstudio

touch $DOTFILES_ROOT/.gitconfig
sudo -u rstudio ln -sfnv $DOTFILES_ROOT/.gitconfig /home/rstudio/.gitconfig

touch $DOTFILES_ROOT/.gitignore_global
sudo -u rstudio ln -sfnv $DOTFILES_ROOT/.gitignore_global /home/rstudio/.gitignore_global
