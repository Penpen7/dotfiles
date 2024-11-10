#!/bin/zsh -xeu

# .zshrc
REPOSITORY_PATH=$(
  cd $(dirname $0)
  pwd
)

${REPOSITORY_PATH}/scripts/make_symlink.sh
source "$HOME/.zshenv"

scripts=(setup_brew.sh setup_node.sh setup_vim.sh)
for i in ${scripts[@]}; do
  ${REPOSITORY_PATH}/scripts/${i}
done
