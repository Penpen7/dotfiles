{ ... }:
{
  programs.eza = {
    enable = true;
    # eza に --icons auto を付けるエイリアスを作る。
    # zsh 連携で ls、ll、la、lt、lla のエイリアスも作られる
    icons = "auto";
  };

  # cd したらディレクトリの中身を表示する
  programs.zsh.siteFunctions.chpwd = ''
    [[ -o interactive && -t 1 ]] || return 0
    pwd
    eza -F --icons=auto
  '';
}
