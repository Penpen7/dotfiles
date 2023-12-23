#!/bin/zsh

# ghq listをfzfで選択してcdする。取得できなかった場合も考慮する
function ghqcd() {
  local dir
  dir=$(ghq list | fzf-tmux --query="$LBUFFER" --select-1 --exit-0) && cd "$(ghq root)/$dir"
}
