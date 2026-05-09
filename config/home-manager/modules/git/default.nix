{ pkgs, ... }:
{
  home.packages = with pkgs; [
    git
    git-secrets
    delta
    gh
    ghq
    hub
  ];

  home.file = {
    ".gitconfig".source = ./gitconfig;
  };
}
