# /bin/zsh

if [ ! -e $HOME/.dircolors-solarized ]; then
  git clone https://github.com/seebi/dircolors-solarized .dircolors-solarized
fi
eval `/usr/local/opt/coreutils/libexec/gnubin/dircolors $HOME/.dircolors-solarized/dircolors.256dark`
if [ -n "$LS_COLORS" ]; then
    zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
fi

if [ ! -e $HOME/.zprezto ]; then
  git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
fi
