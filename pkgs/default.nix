{
  overlays.default = final: prev: {
    tmuxPlugins = prev.tmuxPlugins // {
      open = import ./tmux-plugin-open.nix { pkgs = prev; };
      resurrect = import ./tmux-plugin-resurrect.nix { pkgs = prev; };
      battery = import ./tmux-plugin-battery.nix { pkgs = prev; };
      "pain-control" = import ./tmux-plugin-pain-control.nix { pkgs = prev; };
      tmux-powerline = import ./tmux-plugin-powerline.nix { pkgs = prev; };
    };
    takt = import ./takt.nix { pkgs = final; };
    difit = import ./difit.nix { pkgs = final; };
    ccstatusline = import ./ccstatusline.nix { pkgs = final; };
    mise = import ./mise.nix { pkgs = final; };
    tableplus = import ./tableplus.nix { pkgs = final; };
    # VSCode 1.129 から darwin 版の ripgrep が node_modules.asar.unpacked/ 配下に
    # 移動したが、nixpkgs の postPatch は node_modules/ を決め打ちしていて失敗する。
    # nixpkgs 側が追従したら削除する。
    vscode = prev.vscode.overrideAttrs (old: {
      postPatch = ''
        for rg in \
          Contents/Resources/app/node_modules/@vscode/ripgrep-universal/bin/*/rg \
          Contents/Resources/app/node_modules.asar.unpacked/@vscode/ripgrep-universal/bin/*/rg; do
          [ -f "$rg" ] && chmod +x "$rg"
        done
        true
      '';
    });
  };
}
