{ pkgs, ... }:
{
  home.packages = with pkgs; [
    tmux
    tmux-mem-cpu-load
  ];

  home.file = {
    ".tmux.conf".source = pkgs.replaceVars ./.tmux.conf {
      TMUX_PLUGIN_YANK = "${pkgs.tmuxPlugins.yank.rtp}";
      TMUX_PLUGIN_OPEN = "${pkgs.tmuxPlugins.open.rtp}";
      TMUX_PLUGIN_PAIN_CONTROL = "${pkgs.tmuxPlugins."pain-control".rtp}";
      TMUX_PLUGIN_RESURRECT = "${pkgs.tmuxPlugins.resurrect.rtp}";
      TMUX_PLUGIN_BATTERY = "${pkgs.tmuxPlugins.battery.rtp}";
      TMUX_PLUGIN_POWERLINE = "${pkgs.tmuxPlugins.tmux-powerline.rtp}";
    };
  };

  xdg.configFile = {
    "tmux-powerline" = {
      source = ./powerline;
      recursive = true;
    };
  };
}
