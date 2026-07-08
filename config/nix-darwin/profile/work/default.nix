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
    "/Users/${username}/Applications/Home Manager Apps/Google Chrome.app"
    "/Applications/Gather.app"
    "/Applications/Slack.app"
    "/Applications/Microsoft Outlook.app"
    "/Applications/iTerm.app"
    "/Applications/TablePlus.app"
    "/Applications/zoom.us.app"
    "/Applications/Microsoft Excel.app"
    "/System/Applications/System Settings.app"
  ];
}
