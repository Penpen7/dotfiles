#!/bin/bash -xeu

REPOSITORY_PATH=$(
  cd $(dirname $0)
  pwd
)

ln -sf $REPOSITORY_PATH/zsh/.zshrc $HOME
ln -sf $REPOSITORY_PATH/tmux/.tmux.conf $HOME
ln -sf $REPOSITORY_PATH/zsh/.zshenv $HOME
ln -sf $REPOSITORY_PATH/tig/.tigrc $HOME
ln -sf $REPOSITORY_PATH/preztorc/zpreztorc $HOME/.preztorc

