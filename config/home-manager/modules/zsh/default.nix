{ ... }:
{
  imports = [
    ./env.nix
    ./history.nix
    ./alias.nix
    ./completion.nix
    ./dircolors
    ./keybind.nix
    ./login.nix
  ];

  programs.zsh = {
    enable = true;

    envExtra = ''
      setopt no_global_rcs
    '';
  };
}
