#!/bin/zsh
alias vim='nvim'
alias vi='nvim'
alias v='nvim'
alias gp='git-foresta --all --style=10 | less -RSX'
alias aca='acc submit a.cpp'
alias va='nvim a.cpp'
alias ojt='oj t'
alias ls='eza --icons'
alias vf='vim $(fzf --preview "head -100 {}")'
alias t='tig'
alias docker-clean='docker rm $(docker ps -q -a) && docker system prune --volumes'
alias ll='ls -l'
alias g='git'
