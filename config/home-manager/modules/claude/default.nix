{ pkgs, ... }:
{
  home.packages = [ pkgs.ccstatusline ];

  xdg.configFile = {
    "claude/settings.json".source = ./settings.json;
  };
}
