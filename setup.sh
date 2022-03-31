#!/bin/bash -xeu

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
  apt update && apt install -y curl locales-all build-essential
  brew postinstall gcc
fi

# export PATH
export PATH="$HOMEBREW_PREFIX/bin:$PATH"

if !(type "brew" > /dev/null 2>&1); then
  # brew install
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# brew bundle
brew bundle install

# .zshrc
REPOSITORY_PATH=$(
  cd $(dirname $0)
  pwd
)
# install node
if (type "nodebrew" > /dev/null 2>&1); then
  nodebrew setup
  nodebrew install v16.5.0
  nodebrew use v16.5.0
fi
