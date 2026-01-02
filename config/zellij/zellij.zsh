#!/bin/zsh

# zellij auto start
if [[ ! $TERM_PROGRAM == iTerm.app ]]; then
  return
fi

if [[ ! -n $ZELLIJ && $- == *l* && -t 0 ]]; then
  # Check if zellij is installed
  if ! command -v zellij &> /dev/null; then
    return
  fi

  # get the sessions
  SESSIONS=$(zellij list-sessions --no-formatting 2> /dev/null | grep -v '^zellij: ' | awk '{print $1}')

  if [[ -z "$SESSIONS" ]]; then
    # No sessions, create a new one
    zellij
  else
    # Sessions exist, let user choose
    create_new_session="Create New Session"
    SESSIONS="$SESSIONS\n${create_new_session}"
    SELECTED=$(echo "$SESSIONS" | fzf --height=10 --prompt="Select Zellij session: ")

    if [[ "$SELECTED" = "${create_new_session}" ]]; then
      zellij
    elif [[ -n "$SELECTED" ]]; then
      zellij attach "$SELECTED"
    else
      : # Start terminal normally
    fi
  fi
fi
