{
  pkgs,
  config,
  ...
}:
let
  username = "naoki";
in
{
  imports = [
    ../../modules
    ../../modules/hazeover.nix
    ../../modules/logi-options.nix
    ../../modules/docker.nix
    ../../modules/runcat.nix
    ../../modules/rectangle.nix
    ../../modules/nas.nix
    ../../modules/monitor_wifi.nix
    ../../modules/line.nix
    ../../modules/media.nix
    ../../modules/dtm.nix
    ../../modules/dj.nix
    ../../modules/game.nix
    ../../modules/keyboard.nix
    ../../modules/notes.nix
    ../../modules/finance.nix
    ../../modules/windows-app.nix
  ];

  system.primaryUser = username;

  home-manager.users.${username}.imports = [ ../../../home-manager/profile/personal ];

  system.defaults.dock.persistent-others = [
    "/Users/${username}/Downloads"
  ];

  system.defaults.dock.persistent-apps = [
    "/System/Applications/Launchpad.app"
    "/System/Applications/Calendar.app"
    "/System/Applications/Mail.app"
    "/Applications/Notion.app"
    "/Users/${username}/Applications/Home Manager Apps/Google Chrome.app"
    "/Users/${username}/Applications/Home Manager Apps/Brave Browser.app"
    "/Applications/Slack.app"
    "/Applications/Discord.app"
    "/Applications/iTerm.app"
    "/Applications/LINE.app"
    "/System/Applications/System Settings.app"
  ];
}
