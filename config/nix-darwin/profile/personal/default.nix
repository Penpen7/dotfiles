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
    ../../modules/logi-options.nix
    ../../modules/docker.nix
    ../../modules/runcat.nix
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

  system.defaults.dock.persistent-others = [
    "${config.users.users.${username}.home}/Downloads"
  ];

  system.defaults.dock.persistent-apps = [
    "/System/Applications/Launchpad.app"
    "/System/Applications/Calendar.app"
    "/System/Applications/Notes.app"
    "${pkgs.google-chrome}/Applications/Google Chrome.app"
    "${pkgs.brave}/Applications/Brave Browser.app"
    "/System/Applications/Mail.app"
    "${pkgs.slack}/Applications/Slack.app"
    "${pkgs.discord}/Applications/Discord.app"
    "${pkgs.iterm2}/Applications/iTerm2.app"
    "/Applications/LINE.app"
    "/System/Applications/System Settings.app"
  ];
}
