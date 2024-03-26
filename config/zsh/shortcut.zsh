#!/bin/zsh

# ^でcd ..するようにする
function chpwd() {
  pwd
  eza -F --icons
}
__call_precmds() {
  type precmd > /dev/null 2>&1 && precmd
  for __pre_func in $precmd_functions; do $__pre_func; done
}
