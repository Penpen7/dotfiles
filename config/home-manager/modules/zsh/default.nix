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
    ./functions/fzf.nix
  ];

  programs.zsh = {
    enable = true;

    # setopt no_global_rcs: /etc/zprofile や /etc/zshrc を読み込まない
    envExtra = ''
      setopt no_global_rcs
    '';
  };
}
