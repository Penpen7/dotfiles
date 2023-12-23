### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk
zinit ice depth=1; zinit light romkatv/powerlevel10k
zinit ice wait lucid; zinit light zsh-users/zsh-autosuggestions
zinit ice wait lucid; zinit light zdharma-continuum/fast-syntax-highlighting
zinit ice wait lucid; zinit light zsh-users/zsh-completions

DOTFILE=~/dotfiles/config
if [ ~/.zshrc -nt ~/.zshrc.zwc ]; then
  zcompile ~/.zshrc
fi
shells=(
  $DOTFILE/zsh/dircolor.zsh
  $DOTFILE/powerlevel/.p10k.zsh
  $DOTFILE/zsh/alias.zsh
  $DOTFILE/zsh/option.zsh
  $DOTFILE/zsh/shortcut.zsh
  $DOTFILE/zsh/completions.zsh
  $DOTFILE/fzf/zsh.zsh
  $DOTFILE/fzf/ghq.zsh
  $DOTFILE/fzf/docker.zsh
  $DOTFILE/tmux/split.zsh
  $DOTFILE/tmux/tmux.zsh
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

