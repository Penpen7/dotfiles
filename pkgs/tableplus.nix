{ pkgs }:
let
  # ビルド番号を固定して直接ダウンロードする。
  # 各ビルドの変更履歴とダウンロード URL は下記ページを参照:
  #   https://tableplus.com/blog/2017/02/changelogs.html
  build = "662";
in
pkgs.stdenvNoCC.mkDerivation {
  pname = "tableplus";
  version = build;

  src = pkgs.fetchurl {
    url = "https://files.tableplus.com/macos/${build}/TablePlus.dmg";
    hash = "sha256-VR0sSTZfRjjv+p4DcYciKBJG5DHIwj4KLhTHPGRsSX0=";
  };

  nativeBuildInputs = [ pkgs.undmg ];

  # undmg で展開すると TablePlus.app がカレントに現れるので、その中身を
  # $out/Applications/TablePlus.app へ配置する。
  sourceRoot = "TablePlus.app";

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/Applications/TablePlus.app"
    cp -R . "$out/Applications/TablePlus.app"
    runHook postInstall
  '';

  meta = {
    description = "Modern, native GUI tool for relational databases (pinned build)";
    homepage = "https://tableplus.com";
    platforms = pkgs.lib.platforms.darwin;
  };
}
