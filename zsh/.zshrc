DOTFILE=~/dotfiles
if [ ~/.zshrc -nt ~/.zshrc.zwc ]; then
  zcompile ~/.zshrc
fi
[ -f $DOTFILE/prezto/init.zsh ] && source $DOTFILE/prezto/init.zsh
[ -f $DOTFILE/zsh/alias.zsh ] && source $DOTFILE/zsh/alias.zsh
[ -f $DOTFILE/zsh/option.zsh ] && source $DOTFILE/zsh/option.zsh
[ -f $DOTFILE/zsh/shortcut.zsh ] && source $DOTFILE/zsh/shortcut.zsh
[ -f $DOTFILE/zsh/completions.zsh ] && source $DOTFILE/zsh/completions.zsh
[ -f $DOTFILE/zsh/dircolor.zsh ] && source $DOTFILE/zsh/dircolor.zsh
[ -f $DOTFILE/fzf/zsh.zsh ] && source $DOTFILE/fzf/zsh.zsh
[ -f $DOTFILE/fzf/docker.zsh ] && source $DOTFILE/fzf/docker.zsh
[ -f $DOTFILE/fzf/easy-oneliner.zsh ] && source $DOTFILE/fzf/easy-oneliner.zsh
[ -f $DOTFILE/tmux/split.zsh ] && source $DOTFILE/tmux/split.zsh
[ -f $DOTFILE/tmux/tmux.zsh ] && source $DOTFILE/tmux/tmux.zsh
[ -f $DOTFILE/zsh/keybind.zsh ] && source $DOTFILE/zsh/keybind.zsh
[ -f $DOTFILE/zsh/proxy.zsh ] && source $DOTFILE/zsh/proxy.zsh

find . -type d -name "prezto" -prune -type d -name ".git" -prune -o -type f -name '*.zsh' | while read line; do
  zcompile $line
done
if (which zprof > /dev/null 2>&1); then
  zprof
fi
