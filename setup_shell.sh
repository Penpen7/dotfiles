#!/bin/bash -xeu

REPOSITORY_PATH=$(
  cd $(dirname $0)
  pwd
)

rm -f ~/.zshrc ~/.tmux.conf ~/.zshenv ~/.tigrc ~/.preztorc ~/.hyper.js ~/.gitconfig ~/.p10k.zsh

ln -sf $REPOSITORY_PATH/zsh/.zshrc $HOME
ln -sf $REPOSITORY_PATH/tmux/.tmux.conf $HOME
ln -sf $REPOSITORY_PATH/zsh/.zshenv $HOME
ln -sf $REPOSITORY_PATH/tig/.tigrc $HOME
ln -sf $REPOSITORY_PATH/preztorc/zpreztorc $HOME/.preztorc
ln -sf $REPOSITORY_PATH/hyper/.hyper.js $HOME/.hyper.js
ln -sf $REPOSITORY_PATH/git/gitconfig $HOME/.gitconfig
ln -sf $REPOSITORY_PATH/powerlevel/.p10k.zsh $HOME

