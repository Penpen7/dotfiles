{ ... }:
{
  imports = [
    ./history.nix
    ./cdr.nix
  ];

  programs.fzf = {
    enable = true;
    enableZshIntegration = false;
  };
}
