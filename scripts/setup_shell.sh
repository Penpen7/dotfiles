#!/bin/bash -xeu

REPOSITORY_PATH=$(
  cd ..
  cd $(dirname $0)
  pwd
)

rm -f ~/.zshrc ~/.tmux.conf ~/.zshenv ~/.tigrc ~/.preztorc ~/.hyper.js ~/.gitconfig ~/.p10k.zsh ~/.zprezto

ln -sf $REPOSITORY_PATH/config/zsh/.zshrc $HOME
ln -sf $REPOSITORY_PATH/config/tmux/.tmux.conf $HOME
ln -sf $REPOSITORY_PATH/config/zsh/.zshenv $HOME
ln -sf $REPOSITORY_PATH/config/tig/.tigrc $HOME
ln -sf $REPOSITORY_PATH/config/prezto/zpreztorc $HOME/.zpreztorc
ln -sf $REPOSITORY_PATH/lib/prezto $HOME/.zprezto
ln -sf $REPOSITORY_PATH/config/hyper/.hyper.js $HOME/.hyper.js
ln -sf $REPOSITORY_PATH/config/git/gitconfig $HOME/.gitconfig
ln -sf $REPOSITORY_PATH/config/powerlevel/.p10k.zsh $HOME
NVIM_CONFIG=$HOME/.config/nvim
mkdir -p $NVIM_CONFIG
ln -sf $REPOSITORY_PATH/config/nvim/init.vim $NVIM_CONFIG
ln -sf $REPOSITORY_PATH/config/nvim/dein.toml $NVIM_CONFIG
ln -sf $REPOSITORY_PATH/config/nvim/dein_lazy.toml $NVIM_CONFIG
ln -sf $REPOSITORY_PATH/config/nvim/coc-settings.json $NVIM_CONFIG

