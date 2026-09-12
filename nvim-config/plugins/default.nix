{
  overlays.default =
    final: prev:
    let
      # `extend` を使うことで、nixpkgs 内の他プラグイン（例: CopilotChat-nvim の
      # dependencies）から参照される copilot-lua も差し替え後のものになる。
      # `prev.vimPlugins // { ... }` では属性が置き換わるだけで、内部参照は元のまま。
      vimPluginsOverlay = _: super: {
        fern-renderer-nerdfont = import ./fern-renderer-nerdfont.nix { pkgs = final; };
        fern-git-status = import ./fern-git-status.nix { pkgs = final; };
        nerdfont-vim = import ./nerdfont.nix { pkgs = final; };
        glyph-palette = import ./glyph-palette.nix { pkgs = final; };
        tig-explorer = import ./tig-explorer.nix { pkgs = final; };
        telescope-co-author = import ./telescope-co-author.nix { pkgs = final; };
        vim-rest-console = import ./vim-rest-console.nix { pkgs = final; };
        swagger-preview = import ./swagger-preview.nix { pkgs = final; };
        copilot-lua = import ./copilot-lua.nix {
          pkgs = final;
          prev = super.copilot-lua;
        };
      };
    in
    {
      vimPlugins = prev.vimPlugins.extend vimPluginsOverlay;
    };
}
