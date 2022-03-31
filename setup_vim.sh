#!/bin/bash -xeu

REPOSITORY_PATH=$(
  cd $(dirname $0)
  pwd
)

# nvim
NVIM_CONFIG=$HOME/.config/nvim
mkdir -p $NVIM_CONFIG
ln -sf $REPOSITORY_PATH/nvim/init.vim $NVIM_CONFIG
ln -sf $REPOSITORY_PATH/nvim/dein.toml $NVIM_CONFIG
ln -sf $REPOSITORY_PATH/nvim/dein_lazy.toml $NVIM_CONFIG
ln -sf $REPOSITORY_PATH/nvim/coc-settings.json $NVIM_CONFIG

if (type "npm" > /dev/null 2>&1); then
  # brew install
  npm install -g neovim bash-language-server
fi

# install pynvim
if (type "pip3" > /dev/null 2>&1); then
  pip3 install pynvim
fi

if (type "go" > /dev/null 2>&1); then
  go install github.com/nametake/golangci-lint-langserver@latest
fi
