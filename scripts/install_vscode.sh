#!/bin/sh

REPOSITORY_PATH=$(
  cd $(dirname $0)
  git rev-parse --show-toplevel
)
SCRIPT_DIR=${REPOSITORY_PATH}/config/vscode
VSCODE_SETTING_DIR=~/Library/Application\ Support/Code/User

rm "$VSCODE_SETTING_DIR/settings.json"
ln -sf "$SCRIPT_DIR/settings.json" "${VSCODE_SETTING_DIR}/settings.json"

rm "$VSCODE_SETTING_DIR/keybindings.json"
ln -sf "$SCRIPT_DIR/keybindings.json" "${VSCODE_SETTING_DIR}/keybindings.json"

# install extention
cat ${SCRIPT_DIR}/extensions | while read line; do
  code --install-extension $line
done
