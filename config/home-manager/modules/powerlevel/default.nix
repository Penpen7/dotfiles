{ pkgs, ... }:
{
  programs.zsh.plugins = [
    {
      name = "powerlevel10k";
      src = pkgs.zsh-powerlevel10k;
      file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
    }
    # テーマを読み込んだあとに設定を読み込む
    {
      name = "powerlevel10k-config";
      src = ./.;
      file = ".p10k.zsh";
    }
  ];
}
