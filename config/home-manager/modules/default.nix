{ username, ... }:
{
  home.username = username;
  home.homeDirectory = "/Users/${username}";
  home.stateVersion = "25.11";
  manual.manpages.enable = false;
  manual.json.enable = false;

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
