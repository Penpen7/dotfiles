{
  pkgs,
  username,
  config,
  ...
}:
{
  imports = [
    ../../modules
    ../../modules/hazeover.nix
    ../../modules/docker.nix
    ../../modules/logi-options.nix
    ../../modules/runcat.nix
  ];

  system.defaults.dock.persistent-others = [
    "${config.users.users.${username}.home}/Downloads"
  ];

  system.defaults.dock.persistent-apps = [
    "/System/Applications/Launchpad.app"
    "${pkgs.google-chrome}/Applications/Google Chrome.app"
    "/Applications/Gather.app"
    "${pkgs.slack}/Applications/Slack.app"
    "/Applications/Microsoft Outlook.app"
    "${pkgs.iterm2}/Applications/iTerm2.app"
    "/Applications/TablePlus.app"
    "${pkgs.zoom-us}/Applications/zoom.us.app"
    "/Applications/Microsoft Excel.app"
    "/System/Applications/System Settings.app"
  ];
}
