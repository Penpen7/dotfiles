#!/bin/zsh

bindkey -v

zle -N peco-cdr
bindkey '^o' peco-cdr

zle -N fzf-select-history
bindkey '^r' fzf-select-history

zle -N ch
bindkey '^g' ch

zle -N easy-oneliner
bindkey '^x^x' easy-oneliner

function __tig() {
  tig
}
zle -N __tig
bindkey '^g^t' __tig

function __source() {
  source ~/.zshrc
}
zle -N __source
bindkey -r '^s'
bindkey '^s' __source
