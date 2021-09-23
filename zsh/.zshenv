#!/bin/zsh
# zmodload zsh/zprof && zprof
setopt no_global_rcs

export LC_ALL=ja_JP.UTF-8
export GOPATH="$HOME/go"
export GOBIN="${GOPATH}/bin"

export PATH="/bin":$PATH
export PATH="/usr/bin":$PATH
export PATH="/usr/sbin":$PATH
export PATH="/usr/local/bin":$PATH
export PATH="/usr/local/sbin":$PATH
export PATH="$GOPATH/bin":$PATH
export PATH="$HOME/.nodebrew/current/bin":$PATH
export PATH="$HOME/.cargo/bin:"$PATH
export PATH="/opt/homebrew/bin:"$PATH
export PATH=/usr/local/opt/libexec/gnubin:$PATH
export PATH=/usr/local/opt/llvm/bin:$PATH

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
