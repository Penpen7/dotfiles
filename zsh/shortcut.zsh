#!/bin/zsh

# ^でcd ..するようにする
function chpwd() {
  pwd
  exa -F --icons
}
__call_precmds() {
  type precmd > /dev/null 2>&1 && precmd
  for __pre_func in $precmd_functions; do $__pre_func; done
}
function cdup() {
  echo
  cd ..
  __call_precmds
  zle reset-prompt
}

zle -N cdup
bindkey '\^' cdup
