DOTFILE=~/dotfiles/config
if [ ~/.zshrc -nt ~/.zshrc.zwc ]; then
  zcompile ~/.zshrc
fi
shells=(
  $DOTFILE/zsh/dircolor.zsh
  ~/.zprezto/init.zsh
  ~/.p10k.zsh
  $DOTFILE/zsh/alias.zsh
  $DOTFILE/zsh/option.zsh
  $DOTFILE/zsh/shortcut.zsh
  $DOTFILE/zsh/completions.zsh
  $DOTFILE/fzf/zsh.zsh
  $DOTFILE/fzf/docker.zsh
  $DOTFILE/tmux/split.zsh
  # $DOTFILE/tmux/tmux.zsh
  $DOTFILE/zsh/keybind.zsh
  $DOTFILE/zsh/proxy.zsh
)

for shell in ${shells[@]}; do
  if [ $shell -nt $shell.zwc ]; then
    echo compiling..
    zcompile $shell
  fi
done

for shell in ${shells[@]}; do
  source $shell
done

if (which zprof > /dev/null 2>&1); then
  zprof
fi
