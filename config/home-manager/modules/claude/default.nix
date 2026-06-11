{ pkgs, ... }:
{
  home.packages = [
    pkgs.ccstatusline
    pkgs.llm-agents.claude-code
  ];

  home.file = {
    ".claude/settings.json".source = ./settings.json;
    ".config/ccstatusline/settings.json".source = ./ccstatusline-settings.json;
  };
}
