#!/bin/zsh
#
export TERM="xterm-256color"
export LC_ALL=ja_JP.UTF-8
export PATH="/usr/local/opt/gnu-time/libexec/gnubin:$PATH"
export PATH="/usr/local/Cellar/llvm/10.0.0_3/bin/:$PATH"
export PATH="/usr/local/Cellar/ytop/0.6.2/bin/ytop":$PATH
export PATH="$HOME/.nodebrew/current/bin":$PATH
export EDITOR=vim
export GOBIN=${GOPATH}bin
export LDFLAGS="${LDFLAGS} -L/usr/local/opt/zlib/lib"
export LDFLAGS="${LDFLAGS} -L/usr/local/lib"
export LDFLAGS="${LDFLAGS} -L/usr/local/opt/openssl@1.1/lib"
export LDFLAGS="${LDFLAGS} -L/usr/local/opt/sqlite/lib"
export CPPFLAGS="${CPPFLAGS} -I/usr/local/opt/sqlite/include"
export CPPFLAGS="${CPPFLAGS} -I/usr/local/opt/zlib/include"
export CPPFLAGS="${CPPFLAGS} -I/usr/local/include"
export CPPFLAGS="${CPPFLAGS} -I/usr/local/opt/openssl@1.1/include"
export PKG_CONFIG_PATH="${PKG_CONFIG_PATH} /usr/local/opt/zlib/lib/pkgconfig"
export PKG_CONFIG_PATH="${PKG_CONFIG_PATH} /usr/local/pkgconfig"
export FZF_DEFAULT_OPS="--extended"
export CPATH=$CPATH:/usr/local/include:/Users/naoki/.pyenv/versions/3.6.3/include/python3.6m
