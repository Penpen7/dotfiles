{ ... }:
{
  imports = [
    ./env.nix
    ./history.nix
    ./alias.nix
    ./completion.nix
    ./dircolors.nix
    ./keybind.nix
    ./login.nix
    ./functions/hooks.nix
    ./functions/fzf.nix
    ./functions/docker.nix
  ];

  programs.zsh = {
    enable = true;

    # setopt no_global_rcs: /etc/zprofile や /etc/zshrc を読み込まない
    envExtra = ''
      setopt no_global_rcs
    '';
  };
}
