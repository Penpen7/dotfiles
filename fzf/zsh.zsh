#!/bin/zsh

# cdr
if [[ -n $(echo ${^fpath}/chpwd_recent_dirs(N)) && -n $(echo ${^fpath}/cdr(N)) ]]; then
  autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
  add-zsh-hook chpwd chpwd_recent_dirs
  zstyle ':completion:*' recent-dirs-insert both
  zstyle ':chpwd:*' recent-dirs-default true
  zstyle ':chpwd:*' recent-dirs-max 1000
  zstyle ':chpwd:*' recent-dirs-file "$HOME/.cache/chpwd-recent-dirs"
fi


function fzf-select-history() {
  local selected_command=$(history -n -r 1 | fzf --no-sort --reverse)
  if [ -n "$selected_command" ]; then
    BUFFER="${selected_command}"
  fi
}

function peco-cdr () {
      local selected_dir=$(cdr -l | awk '{ print $2 }' | \
      fzf --reverse --ansi --preview 'f() { zsh -c "exa -1 --icons $1" }; f {}')
    if [ -n "$selected_dir" ]; then
        BUFFER="cd ${selected_dir}"
        zle accept-line
    fi
}
