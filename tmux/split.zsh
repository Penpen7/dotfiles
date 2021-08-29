#!/bin/zsh

# set tmux panes for ide
function tsplit() {
  if [ "$#" -eq 0 ]; then
    tmux split-window -v
    tmux split-window -h
    tmux resize-pane -D 15
    tmux select-pane -t 1
  else
    case $1 in
      1)
        tmux split-window -v
        tmux resize-pane -D 15
        tmux select-pane -D
        clear
        ;;
      2)
        tmux split-window -h
        tmux split-window -v
        tmux resize-pane -D 15
        tmux select-pane -t 1
        tmux split-window -v
        tmux select-pane -t 1
        clear
        ;;
      py)
        cd $2
        tmux split-window -v
        tmux split-window -h
        tmux resize-pane -D 15
        tmux select-pane -t 1
        vi .
        clear
        ;;
      *)
        echo [ERROR] "$1" は設定されていない引数です。
        ;;
    esac
  fi
}
