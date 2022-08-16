#!/bin/bash -xeu

REPOSITORY_PATH=$(
  cd $(dirname $0)
  pwd
)

# nvim

export PATH="$PATH:$HOME/.nodebrew/current/bin"

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

brew install expect

expect -c "
set timeout 600
spawn nvim --headless +:UpdateRemotePlugins
expect {
  \"続けるにはENTERを押すかコマンドを入力してください\" {
    send \"\r\"
  }
  failed abort
  timeout abort
}
"

timeout 2m nvim --headless +CocInstall || exit 0
