{ pkgs, ... }:
{
  home.packages = with pkgs; [
    git
    git-secrets
    delta
    gh
    ghq
    hub
    lazygit # git の TUI クライアント
  ];

  home.file = {
    ".gitconfig".source = ./gitconfig;
  };
}
