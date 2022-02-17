# /bin/zsh
#
cd $(dirname $0)
eval `dircolors grubox.dircolors`
if [ -n "$LS_COLORS" ]; then
    zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
fi
