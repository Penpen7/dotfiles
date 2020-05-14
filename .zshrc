#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

export TERM="xterm-256color" 
POWERLEVEL9K_MODE="nerdfont-complete"
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(user dir battery newline vcs)
# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Customize to your needs...
fpath=(/usr/local/share/zsh-completions /usr/local/share/zsh-autosuggestions $fpath)
export LC_ALL=ja_JP.UTF-8

export QT_HOMEBREW=true
alias ..='cd ..'
alias ...='cd ../../'
alias ....='cd ../../../'
alias v='vim'
alias gp='git-foresta --all --style=10 | less -RSX'
