#!/bin/zsh

bindkey -v
bindkey "jj" vi-cmd-mode

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

function __vim() {
  nvim
}
zle -N __vim
bindkey -r '^v'
bindkey '^v' __vim

zle -N docker-sh
bindkey '^x^s' docker-sh
zle -N docker-run
bindkey '^x^r' docker-run
zle -N docker-bash
bindkey '^x^b' docker-bash