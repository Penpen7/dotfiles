{ pkgs, lib, ... }:
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

  # split.zsh の vi がエイリアス (vi=nvim) で展開されるよう、エイリアス定義 (1100) より後に読み込む
  programs.zsh.initContent = lib.mkOrder 1110 ''
    source ${./split.zsh}
    source ${./tmux.zsh}
  '';

  xdg.configFile = {
    "tmux-powerline" = {
      source = ./powerline;
      recursive = true;
    };
  };
}
