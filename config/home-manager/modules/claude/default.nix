{ pkgs, ... }:
{
  home.packages = [ pkgs.ccstatusline ];

  home.file = {
    ".claude/settings.json".source = ./settings.json;
    ".config/ccstatusline/settings.json".source = ./ccstatusline-settings.json;
  };
}
