#!/bin/zsh

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
fi

setopt no_global_rcs

export LC_ALL=ja_JP.UTF-8
export GOPATH="$HOME/go"
export GOBIN="${GOPATH}/bin"

export PATH="/bin":$PATH
export PATH="/usr/bin":$PATH
export PATH="/usr/sbin":$PATH
export PATH="/usr/local/bin":$PATH
export PATH="/usr/local/sbin":$PATH
export PATH="${HOMEBREW_PREFIX}/bin":$PATH
export PATH="${HOMEBREW_PREFIX}/sbin":$PATH
export PATH="$GOPATH/bin":$PATH
export PATH="$HOME/.nodebrew/current/bin":$PATH
export PATH="$HOME/.cargo/bin:"$PATH
export PATH=${HOMEBREW_PREFIX}/opt/coreutils/libexec/gnubin:$PATH
export PATH=${HOMEBREW_PREFIX}/opt/llvm/bin:$PATH
export PATH=$HOME/Library/Python/3.8/bin:$PATH

export LDFLAGS="${LDFLAGS} -L/usr/local/lib"
export CPPFLAGS="${CPPFLAGS} -I/usr/local/include"
export PKG_CONFIG_PATH="${PKG_CONFIG_PATH} /usr/local/pkgconfig"
#   export LDFLAGS="${LDFLAGS} -L$(brew --prefix zlib)/lib"
#   export LDFLAGS="${LDFLAGS} -L$(brew --prefix sqlite)/lib"
#   export CPPFLAGS="${CPPFLAGS} -I$(brew --prefix zlib)/include"
#   export CPPFLAGS="${CPPFLAGS} -I$(brew --prefix sqlite)/include"
#   export PKG_CONFIG_PATH="${PKG_CONFIG_PATH} /usr/local/opt/zlib/lib/pkgconfig"

export FZF_DEFAULT_OPS="--extended"
export EDITOR=nvim
export GIT_EDITOR=nvim
. "$HOME/.cargo/env"
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_GOOGLE_ANALYTICS=1
