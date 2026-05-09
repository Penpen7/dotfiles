{ username, ... }:
{
  home.username = username;
  home.homeDirectory = "/Users/${username}";
  home.stateVersion = "25.11";
  nixpkgs.config.allowUnfree = true;

  programs.home-manager.enable = true;

  imports = [
    ./standalone
    ./nvim
    ./zsh
    ./git
    ./tmux
    ./vscode
    ./zellij
    ./claude
    ./hyper
    ./intellij
    ./powerlevel
    ./tig
    ./brave
    ./chrome
    ./go
    ./rust
    ./flutter
  ];
}
