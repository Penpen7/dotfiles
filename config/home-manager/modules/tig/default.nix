{ pkgs, ... }:
{
  home.packages = with pkgs; [ tig ];

  home.file = {
    ".tigrc".source = ./.tigrc;
  };
}
