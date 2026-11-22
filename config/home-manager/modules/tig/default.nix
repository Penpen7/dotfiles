{ pkgs, ... }:
{
  home.packages = with pkgs; [ tig ];

  home.file = {
    ".tigrc".source = ./.tigrc;
  };

  programs.zsh = {
    shellAliases.t = "tig";
    siteFunctions.__tig = "tig";
  };

  my.zsh.keybindings."^g^t" = "__tig";
}
