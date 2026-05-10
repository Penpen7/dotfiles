# PATH
typeset -U path
export PATH="$HOMEBREW_PREFIX/bin":$PATH
export PATH="$HOMEBREW_PREFIX/sbin":$PATH
export PATH="$GOPATH/bin":$PATH
export PATH="$HOME/.cargo/bin:"$PATH
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.bun/bin:$PATH"

# Nix (最後に追加することで優先される)
if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
  source '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi
. "/etc/profiles/per-user/$USER/etc/profile.d/hm-session-vars.sh"

source @zinit@/zinit.zsh
autoload -Uz _zinit
((${+_comps})) && _comps[zinit]=_zinit
zinit ice depth=1
zinit light @zshPowerlevel10k@
zinit ice wait lucid
zinit light @zshAutosuggestions@
zinit ice wait lucid
zinit light @zshFastSyntaxHighlighting@
zinit ice wait lucid
zinit light @zshCompletions@

DOTFILE=~/dotfiles/config
HOME_MANAGER_MODULES=$DOTFILE/home-manager/modules
if [ ~/.zshrc -nt ~/.zshrc.zwc ]; then
  zcompile ~/.zshrc
fi
shells=(
  $HOME_MANAGER_MODULES/zsh/dircolor.zsh
  $HOME_MANAGER_MODULES/powerlevel/.p10k.zsh
  $HOME_MANAGER_MODULES/zsh/alias.zsh
  $HOME_MANAGER_MODULES/zsh/option.zsh
  $HOME_MANAGER_MODULES/zsh/shortcut.zsh
  $HOME_MANAGER_MODULES/zsh/completions.zsh
  $DOTFILE/fzf/zsh.zsh
  $DOTFILE/fzf/ghq.zsh
  $DOTFILE/fzf/docker.zsh
  $HOME_MANAGER_MODULES/tmux/split.zsh
  $HOME_MANAGER_MODULES/tmux/tmux.zsh
  $HOME_MANAGER_MODULES/zsh/keybind.zsh
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

# dotfilesでgitの差分があればメッセージを出力する
if [ -n "$(git -C ~/dotfiles status --porcelain)" ]; then
  echo "[INFO] dotfilesに差分があります。早めにレポジトリに反映してください。"
fi

# Downloads内でのファイル数とサイズを表示
function download_info() {
  # Downloadsが存在しない場合は何もしない
  if [ ! -d ~/Downloads ]; then
    return
  fi
  echo "Downloads内のファイル数: $(find ~/Downloads -type f | wc -l)"
  echo "Downloads内のファイルサイズ: $(du -sh ~/Downloads | awk '{print $1}')"
}

download_info

function precmd() {
  if [ -n "$TMUX" ]; then
    tmux refresh-client -S
  fi
}
