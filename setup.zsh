#!/bin/zsh

# .zshrc
REPOSITORY_PATH=$(cd $(dirname $0); pwd)
ln -sf $REPOSITORY_PATH/zsh/.zshrc $HOME
ln -sf $REPOSITORY_PATH/tmux/.tmux.conf $HOME
ln -sf $REPOSITORY_PATH/zsh/.zshenv

# nvim
NVIM_CONFIG=$HOME/.config/nvim
mkdir -p $NVIM_CONFIG
ln -sf $REPOSITORY_PATH/nvim/init.vim $NVIM_CONFIG
ln -sf $REPOSITORY_PATH/nvim/dein.toml $NVIM_CONFIG
ln -sf $REPOSITORY_PATH/nvim/dein_lazy.toml $NVIM_CONFIG
