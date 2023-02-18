#!/bin/zsh

function __tig() {
  tig
}

function __source() {
  source ~/.zshrc
}

function __vim() {
  nvim
}

zle -N docker-bash
zle -N docker-run
zle -N docker-sh
zle -N __vim
zle -N __source
zle -N peco-cdr
zle -N fzf-select-history
zle -N ch
zle -N easy-oneliner
zle -N __tig

bindkey -v
bindkey -r '^r'
bindkey -r '^s'
bindkey -r '^v'
bindkey "jj" vi-cmd-mode
bindkey '^g' ch
bindkey '^g^t' __tig
bindkey '^o' peco-cdr
bindkey '^r' fzf-select-history
bindkey '^s' __source
bindkey '^v' __vim
bindkey '^x^b' docker-bash
bindkey '^x^r' docker-run
bindkey '^x^s' docker-sh
bindkey '^x^x' easy-oneliner
