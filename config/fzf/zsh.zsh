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
      fzf --reverse --ansi --preview 'f() { zsh -c "eza -1 --icons $1" }; f {}')
    if [ -n "$selected_dir" ]; then
        BUFFER="cd ${selected_dir}"
        zle accept-line
    fi
}

function ch() {
  local cols sep google_history open
  cols=$(( COLUMNS / 3 ))
  sep='{::}'

  if [ "$(uname)" = "Darwin" ]; then
    google_history="$HOME/Library/Application Support/Google/Chrome/Default/History"
    open=open
  else
    google_history="$HOME/.config/google-chrome/Default/History"
    open=xdg-open
  fi
  \cp -f "$google_history" /tmp/googlechrome_fzf
  sqlite3 -separator $sep /tmp/googlechrome_fzf \
    "select substr(title, 1, $cols), url
      from urls order by last_visit_time desc" |
  awk -F $sep '{printf "%-'$cols's  \x1b[36m%s\x1b[m\n", $1, $2}' | 
  fzf --reverse --no-hscroll --ansi --multi --preview-window down:0 | sed 's#.*\(https*://\)#\1#' | xargs $open > /dev/null 2> /dev/null
}

alias gitc='git branch | fzf --reverse --ansi | xargs git checkout'
