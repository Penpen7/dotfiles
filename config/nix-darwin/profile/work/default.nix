{
  pkgs,
  config,
  ...
}:
let
  username = "naoki.uehara";
in
{
  imports = [
    ../../modules
    ../../modules/hazeover.nix
    ../../modules/docker.nix
    ../../modules/gather.nix
    ../../modules/logi-options.nix
    ../../modules/runcat.nix
    ../../modules/rectangle.nix
  ];

  system.primaryUser = username;

  home-manager.users.${username}.imports = [ ../../../home-manager/profile/work ];

  system.defaults.dock.persistent-others = [
    "/Users/${username}/Downloads"
  ];

  system.defaults.dock.persistent-apps = [
    "/System/Applications/Launchpad.app"
    "${pkgs.google-chrome}/Applications/Google Chrome.app"
    "/Applications/Gather.app"
    "/Applications/Slack.app"
    "/Applications/Microsoft Outlook.app"
    "${pkgs.iterm2}/Applications/iTerm2.app"
    "/Applications/TablePlus.app"
    "${pkgs.zoom-us}/Applications/zoom.us.app"
    "/Applications/Microsoft Excel.app"
    "/System/Applications/System Settings.app"
  ];
}
