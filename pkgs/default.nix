{
  overlays.default = final: prev: {
    vimPlugins = prev.vimPlugins // {
      fern-renderer-nerdfont = import ./nvim-fern-renderer-nerdfont.nix { pkgs = final; };
      fern-git-status = import ./nvim-fern-git-status.nix { pkgs = final; };
      nerdfont-vim = import ./nvim-nerdfont.nix { pkgs = final; };
      glyph-palette = import ./nvim-glyph-palette.nix { pkgs = final; };
      tig-explorer = import ./nvim-tig-explorer.nix { pkgs = final; };
      telescope-co-author = import ./nvim-telescope-co-author.nix { pkgs = final; };
      vim-rest-console = import ./nvim-vim-rest-console.nix { pkgs = final; };
      swagger-preview = import ./nvim-swagger-preview.nix { pkgs = final; };
    };
    tmuxPlugins = prev.tmuxPlugins // {
      open = import ./tmux-plugin-open.nix { pkgs = prev; };
      resurrect = import ./tmux-plugin-resurrect.nix { pkgs = prev; };
      battery = import ./tmux-plugin-battery.nix { pkgs = prev; };
      "pain-control" = import ./tmux-plugin-pain-control.nix { pkgs = prev; };
      tmux-powerline = import ./tmux-plugin-powerline.nix { pkgs = prev; };
    };
    takt = import ./takt.nix { pkgs = final; };
  };
}
