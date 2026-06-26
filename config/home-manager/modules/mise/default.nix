{ pkgs, ... }:
{
  programs.mise.enable = true;
  # pkgs/mise.nix で GitHub Releases のビルド済みバイナリを使用する
  programs.mise.package = pkgs.mise;
}
