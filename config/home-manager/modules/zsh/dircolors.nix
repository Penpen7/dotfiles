{ lib, ... }:
{
  programs.dircolors = {
    enable = true;
    # Home Manager の既定値は使わず、nord.dircolors だけを使う
    settings = lib.mkForce { };
    extraConfig = builtins.readFile ./nord.dircolors;
  };

  # 補完候補も LS_COLORS で色分けする
  programs.zsh.initContent = ''
    zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}
  '';
}
