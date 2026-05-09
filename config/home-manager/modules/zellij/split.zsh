#!/bin/zsh

# set zellij panes for ide
function zsplit() {
  if [ "$#" -eq 0 ]; then
    zellij action new-pane --direction down
    zellij action new-pane --direction right
    zellij action resize --resize-direction up 15
    zellij action move-focus up
  else
    case $1 in
      1)
        zellij action new-pane --direction down
        zellij action resize --resize-direction up 15
        zellij action move-focus down
        clear
        ;;
      2)
        zellij action new-pane --direction right
        zellij action new-pane --direction down
        zellij action resize --resize-direction up 15
        zellij action move-focus up
        zellij action new-pane --direction down
        zellij action move-focus up
        clear
        ;;
      py)
        cd $2
        zellij action new-pane --direction down
        zellij action new-pane --direction right
        zellij action resize --resize-direction up 15
        zellij action move-focus up
        vi .
        clear
        ;;
      *)
        echo [ERROR] "$1" は設定されていない引数です。
        ;;
    esac
  fi
}