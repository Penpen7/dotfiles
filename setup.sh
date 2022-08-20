#!/bin/bash -xeu

# .zshrc
REPOSITORY_PATH=$(
  cd $(dirname $0)
  pwd
)
scripts=(make_symlink.sh setup_brew.sh setup_node.sh setup_vim.sh)
for i in ${!scripts[@]}; do
  $REPOSITORY_PATH/scripts/$i
done
