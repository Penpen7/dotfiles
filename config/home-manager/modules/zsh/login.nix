{ ... }:
{
  # ログインシェルの起動時に表示する
  programs.zsh.loginExtra = ''
    # dotfilesでgitの差分があればメッセージを出力する
    if [ -n "$(git -C ~/dotfiles status --porcelain)" ]; then
      echo "[INFO] dotfilesに差分があります。早めにレポジトリに反映してください。"
    fi

    # Downloads内でのファイル数とサイズを表示
    if [ -d ~/Downloads ]; then
      echo "Downloads内のファイル数: $(find ~/Downloads -type f | wc -l)"
      echo "Downloads内のファイルサイズ: $(du -sh ~/Downloads | awk '{print $1}')"
    fi
  '';
}
