#!/bin/bash -xeu

REPOSITORY_PATH=$(
  cd $(dirname $0)
  git rev-parse --show-toplevel
)

ln -sf $REPOSITORY_PATH/config/zsh/.zshrc $HOME/.zshrc
ln -sf $REPOSITORY_PATH/config/tmux/.tmux.conf $HOME/.tmux.conf
ln -sf $REPOSITORY_PATH/config/zsh/.zshenv $HOME/.zshenv
ln -sf $REPOSITORY_PATH/config/tig/.tigrc $HOME/.tigrc
ln -sf $REPOSITORY_PATH/config/hyper/.hyper.js $HOME/.hyper.js
ln -sf $REPOSITORY_PATH/config/git/gitconfig $HOME/.gitconfig
ln -sf $REPOSITORY_PATH/config/powerlevel/.p10k.zsh $HOME/.p10k.zsh
ln -sf $REPOSITORY_PATH/config/intellij/.ideavimrc $HOME/.ideavimrc
NVIM_CONFIG=$HOME/.config/nvim
mkdir -p $NVIM_CONFIG
ln -sf $REPOSITORY_PATH/config/nvim/init.lua $NVIM_CONFIG
ln -sf $REPOSITORY_PATH/config/nvim/lua $NVIM_CONFIG
ln -sf $REPOSITORY_PATH/config/nvim/coc-settings.json $NVIM_CONFIG
mv $HOME/.config/powerline $HOME/.config/powerline.bak
ln -sf $REPOSITORY_PATH/config/powerline/config ~/.config/powerline

if [ -d $HOME/.config/tmux-powerline ]; then
  date=$(date +%Y%m%d)
  echo "Backing up existing tmux-powerline config to ~/.config/tmux-powerline.bak${date}"
fi
ln -sf $REPOSITORY_PATH/config/tmux-powerline ~/.config/tmux-powerline
