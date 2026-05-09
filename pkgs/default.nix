{
  overlays.default = final: prev: {
    powerlinePython = import ./powerline-python.nix { pkgs = final; };
    tmuxPluginOpen = import ./tmux-plugin-open.nix { pkgs = final; };
    tmuxPluginResurrect = import ./tmux-plugin-resurrect.nix { pkgs = final; };
    tmuxPluginBattery = import ./tmux-plugin-battery.nix { pkgs = final; };
    tmuxPluginPainControl = import ./tmux-plugin-pain-control.nix { pkgs = final; };
    tmuxPluginPowerline = import ./tmux-plugin-powerline.nix { pkgs = final; };
    nvimFernRendererNerdfont = import ./nvim-fern-renderer-nerdfont.nix { pkgs = final; };
    nvimFernGitStatus = import ./nvim-fern-git-status.nix { pkgs = final; };
    nvimNerdfont = import ./nvim-nerdfont.nix { pkgs = final; };
    nvimGlyphPalette = import ./nvim-glyph-palette.nix { pkgs = final; };
    nvimTigExplorer = import ./nvim-tig-explorer.nix { pkgs = final; };
    nvimTelescopeCoAuthor = import ./nvim-telescope-co-author.nix { pkgs = final; };
    nvimVimRestConsole = import ./nvim-vim-rest-console.nix { pkgs = final; };
    nvimSwaggerPreview = import ./nvim-swagger-preview.nix { pkgs = final; };
  };
}
