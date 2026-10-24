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
    cleanshot = import ./cleanshot.nix { pkgs = final; };
    # viceroy 0.21.1 は release ビルドで deny(warnings) を有効にしており、
    # 新しい rustc で std::u32::MAX の deprecated 警告がエラーになって失敗する
    # (fastly の依存)。nixpkgs 側が追従したら削除する。
    viceroy = prev.viceroy.overrideAttrs (old: {
      env = (old.env or { }) // {
        RUSTFLAGS = "--cap-lints warn";
      };
    });
    # Qt 6.12 以降、darwin で parts.db 生成後の終了処理中に Fritzing が
    # Bus error で落ちて postFixup が失敗する。DB 自体は書き終わっているので、
    # 異常終了は許容しつつ parts.db が正しく生成されたことだけ確認する。
    # nixpkgs 側が追従したら削除する。
    fritzing = prev.fritzing.overrideAttrs (old: {
      nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ prev.sqlite ];
      postFixup = ''
        db="$out/share/fritzing/parts/parts.db"
        QT_QPA_PLATFORM=offscreen "$out/bin/Fritzing" \
          -db "$db" \
          -pp "$out/share/fritzing/parts" \
          -folder "$out/share/fritzing" \
          || echo "Fritzing exited with $?, checking parts.db"
        test "$(sqlite3 "$db" 'PRAGMA integrity_check;')" = ok
        test "$(sqlite3 "$db" 'SELECT COUNT(*) FROM parts;')" -gt 0
      '';
    });
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
