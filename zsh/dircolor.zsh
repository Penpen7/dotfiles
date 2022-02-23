# /bin/zsh
#
local sourcedirectory=$(dirname $0)
eval `dircolors ${sourcedirectory}/grubox.dircolors`
if [ -n "$LS_COLORS" ]; then
    zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
fi
