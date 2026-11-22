{ ... }:
{
  programs.eza = {
    enable = true;
    icons = "auto";
  };

  # cd したらディレクトリの中身を表示する
  programs.zsh.siteFunctions.chpwd = ''
    [[ -o interactive && -t 1 ]] || return 0
    pwd
    eza -F --icons=auto
  '';
}
