# Customize to your needs...
fpath=(/usr/local/share/zsh-completions /usr/local/share/zsh-autosuggestions $fpath)
ZSH_AUTOSUGGEST_STRATEGY=(completion history)

# taskコマンドがある場合のみ補完を有効にする
if which task > /dev/null 2>&1; then
  eval "$(task --completion zsh)"
fi
