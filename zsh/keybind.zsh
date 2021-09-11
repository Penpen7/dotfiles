#!/bin/zsh

bindkey -v

zle -N peco-cdr
bindkey '^o' peco-cdr

zle -N fzf-select-history
bindkey '^r' fzf-select-history

zle -N ch
bindkey '^g' ch
