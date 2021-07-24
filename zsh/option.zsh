setopt auto_cd
setopt auto_pushd
setopt correct
setopt pushd_ignore_dups
autoload -U compinit
compinit
zstyle ':completion:*:default' menu select=1
