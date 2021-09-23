#!/bin/sh

# zmodload zsh/zprof && zprof
# First check OS.
OS="$(uname)"
if [[ "${OS}" == "Linux" ]]; then
  HOMEBREW_ON_LINUX=1
elif [[ "${OS}" != "Darwin" ]]; then
  echo "Homebrew is only supported on macOS and Linux."
fi

if [[ -z "${HOMEBREW_ON_LINUX-}" ]]; then
  UNAME_MACHINE="$(/usr/bin/uname -m)"

  if [[ "${UNAME_MACHINE}" == "arm64" ]]; then
    # On ARM macOS, this script installs to /opt/homebrew only
    HOMEBREW_PREFIX="/opt/homebrew"
  else
    # On Intel macOS, this script installs to /usr/local only
    HOMEBREW_PREFIX="/usr/local"
  fi
else
  UNAME_MACHINE="$(uname -m)"
  HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew"
  sudo apt install -y curl locales-all build-essential
fi

# export PATH
export PATH="$HOMEBREW_PREFIX/bin:$PATH"

if !(type "brew" > /dev/null 2>&1); then
  # brew install
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

brew bundle

# .zshrc
REPOSITORY_PATH=$(
  cd $(dirname $0)
  pwd
)
ln -sf $REPOSITORY_PATH/zsh/.zshrc $HOME
ln -sf $REPOSITORY_PATH/tmux/.tmux.conf $HOME
ln -sf $REPOSITORY_PATH/zsh/.zshenv $HOME
ln -sf $REPOSITORY_PATH/tig/.tigrc $HOME
ln -sf $REPOSITORY_PATH/preztorc/zpreztorc $HOME/.preztorc

# nvim
NVIM_CONFIG=$HOME/.config/nvim
mkdir -p $NVIM_CONFIG
ln -sf $REPOSITORY_PATH/nvim/init.vim $NVIM_CONFIG
ln -sf $REPOSITORY_PATH/nvim/dein.toml $NVIM_CONFIG
ln -sf $REPOSITORY_PATH/nvim/dein_lazy.toml $NVIM_CONFIG
ln -sf $REPOSITORY_PATH/nvim/coc-settings.json $NVIM_CONFIG

# install node
if !(type "nodebrew" > /dev/null 2>&1); then
  nodebrew setup
  nodebrew install v16.5.0
  nodebrew use v16.5.0
fi

if !(type "npm" > /dev/null 2>&1); then
  # brew install
  npm install -g nvim bash-language-server
fi

if (type "go" > /dev/null 2>&1); then
  go get github.com/nametake/golangci-lint-langserver
fi

# install node
if !(type "pip3" > /dev/null 2>&1); then
  pip3 install pynvim
  nodebrew use v16.5.0
fi
