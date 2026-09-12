# copilot.lua は 2026-09 に上流が同梱 LSP (copilot/js) を履歴から消すため
# git 履歴を書き換え、既存タグ v3.0.4 も書き換え後のコミットへ付け替えられた。
# その結果 nixpkgs が記録している v3.0.4 のハッシュと tarball の内容が一致しなくなり
# fixed-output derivation の hash mismatch でビルドが失敗する。
# nixpkgs が 3.1.x に更新されるまでの間、書き換え後の内容のハッシュで src を差し替える。
{ pkgs, prev }:
prev.overrideAttrs (
  old:
  pkgs.lib.optionalAttrs (old.version == "3.0.4") {
    src = pkgs.fetchFromGitHub {
      owner = "zbirenbaum";
      repo = "copilot.lua";
      tag = "v3.0.4";
      hash = "sha256-kDQOm7/N6T7wOw1JlkcxNMnQrDE4oTRyGCZkvT8HZQw=";
    };
  }
)
