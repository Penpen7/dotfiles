setopt auto_cd
setopt auto_pushd
setopt correct
setopt pushd_ignore_dups
# 履歴保存管理
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=1000000

# 他のzshと履歴を共有
setopt inc_append_history
setopt share_history
## 補完で小文字でも大文字にマッチさせる
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*:default' menu select=1
_compinit() {
  local re_initialize=0
  for match in ${ZDOTDIR}/.zcompdump*(.Nmh+24); do
    re_initialize=1
    break
  done

  autoload -Uz compinit
  if [ "$re_initialize" -eq "1" ]; then
    compinit
    # update the timestamp on compdump file
    compdump
  else
    # omit the check for new functions since we updated today
    compinit -C
  fi
}
_compinit
