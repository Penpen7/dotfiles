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
    # Qt 6.12 以降、darwin で parts.db 生成後の終了処理中に Fritzing が
    # Bus error で落ちて postFixup が失敗する。DB 自体は書き終わっているので、
    # 異常終了は許容しつつ parts.db が正しく生成されたことだけ確認する。
    # nixpkgs ではこの失敗を受けて darwin で broken 扱いになっているので
    # (NixOS/nixpkgs#588230)、回避策を入れたうえで broken を外す。
    # また 1.0.8 の phoenix.pro は x86_64/arm64 の universal ビルドを決め打ちしており、
    # nix の依存 (Qt, libgit2 など) は単一アーキテクチャなのでリンクに失敗する。
    # ビルド対象のアーキテクチャだけに絞る。
    # nixpkgs 側が追従したら削除する。
    fritzing = prev.fritzing.overrideAttrs (old: {
      meta = old.meta // {
        broken = false;
      };
      postPatch =
        (old.postPatch or "")
        + prev.lib.optionalString prev.stdenv.hostPlatform.isDarwin ''
          substituteInPlace phoenix.pro \
            --replace-fail "QMAKE_APPLE_DEVICE_ARCHS = x86_64 arm64" \
              "QMAKE_APPLE_DEVICE_ARCHS = ${prev.stdenv.hostPlatform.darwinArch}"
        '';
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
