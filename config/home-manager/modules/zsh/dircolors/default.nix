{ lib, ... }:
{
  programs.dircolors = {
    enable = true;
    settings = lib.mkForce { };
    extraConfig = builtins.readFile ./nord.dircolors;
  };

  programs.zsh.initContent = ''
    zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}
  '';
}
