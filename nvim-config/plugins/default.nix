{
  overlays.default = final: prev: {
    vimPlugins = prev.vimPlugins // {
      fern-renderer-nerdfont = import ./fern-renderer-nerdfont.nix { pkgs = final; };
      fern-git-status        = import ./fern-git-status.nix        { pkgs = final; };
      nerdfont-vim           = import ./nerdfont.nix                { pkgs = final; };
      glyph-palette          = import ./glyph-palette.nix           { pkgs = final; };
      tig-explorer           = import ./tig-explorer.nix            { pkgs = final; };
      telescope-co-author    = import ./telescope-co-author.nix     { pkgs = final; };
      vim-rest-console       = import ./vim-rest-console.nix        { pkgs = final; };
      swagger-preview        = import ./swagger-preview.nix         { pkgs = final; };
    };
  };
}
