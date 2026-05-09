{ pkgs, ... }:
{
  home.packages = with pkgs; [
    tmux
    tmux-mem-cpu-load
    powerlinePython
  ];

  home.file = {
    ".tmux.conf".source = pkgs.replaceVars ./.tmux.conf {
      TMUX_PLUGIN_YANK = "${pkgs.tmuxPlugins.yank.rtp}";
      TMUX_PLUGIN_OPEN = "${pkgs.tmuxPluginOpen.rtp}";
      TMUX_PLUGIN_PAIN_CONTROL = "${pkgs.tmuxPluginPainControl.rtp}";
      TMUX_PLUGIN_RESURRECT = "${pkgs.tmuxPluginResurrect.rtp}";
      TMUX_PLUGIN_BATTERY = "${pkgs.tmuxPluginBattery.rtp}";
      TMUX_PLUGIN_POWERLINE = "${pkgs.tmuxPluginPowerline.rtp}";
    };
  };

  xdg.configFile = {
    "tmux-powerline" = {
      source = ./powerline;
      recursive = true;
    };
  };
}
