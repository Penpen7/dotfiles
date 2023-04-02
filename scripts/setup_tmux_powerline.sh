#!/bin/bash

pip3 install powerline-status
pip3 install powerline-mem-segment
pip3 show -f powerline-status | grep "powerline.conf$"
mkdir -p ~/.config/powerline/{colorschemes,themes}/tmux

REPOSITORY_PATH=$(
  cd $(dirname $0)
  git rev-parse --show-toplevel
)

ln -s "$REPOSITORY_PATH/config/powerline/tmux/config.json" ~/.config/powerline/config.json
ln -s "$REPOSITORY_PATH/config/powerline/tmux/colors.json" ~/.config/powerline/colors.json
ln -s "$REPOSITORY_PATH/config/powerline/tmux/tmux-theme.json" ~/.config/powerline/themes/tmux/tmux-theme.json
ln -s "$REPOSITORY_PATH/config/powerline/colorscheme.json" ~/.config/powerline/colorschemes/tmux/tmux-colorscheme.json
