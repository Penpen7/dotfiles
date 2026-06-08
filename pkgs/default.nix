{
  overlays.default = final: prev: {
    tmuxPlugins = prev.tmuxPlugins // {
      open          = import ./tmux-plugin-open.nix       { pkgs = prev; };
      resurrect     = import ./tmux-plugin-resurrect.nix  { pkgs = prev; };
      battery       = import ./tmux-plugin-battery.nix    { pkgs = prev; };
      "pain-control" = import ./tmux-plugin-pain-control.nix { pkgs = prev; };
      tmux-powerline = import ./tmux-plugin-powerline.nix { pkgs = prev; };
    };
    takt = import ./takt.nix { pkgs = final; };
    ccstatusline = import ./ccstatusline.nix { pkgs = final; };
    brave = import ./brave.nix { pkgs = prev; };
  };
}
