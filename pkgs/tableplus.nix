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

  nativeBuildInputs = [ pkgs._7zz ];

  # 最近の TablePlus.dmg は APFS 形式のため undmg では展開できない。
  # _7zz なら APFS DMG も扱えるので、これで展開して TablePlus.app を取り出す。
  unpackPhase = ''
    runHook preUnpack
    7zz x "$src" -o_dmg
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall
    app=$(find _dmg -maxdepth 3 -name 'TablePlus.app' -type d | head -n1)
    if [ -z "$app" ]; then
      echo "TablePlus.app not found in extracted DMG" >&2
      exit 1
    fi
    mkdir -p "$out/Applications/TablePlus.app"
    cp -R "$app/." "$out/Applications/TablePlus.app"
    runHook postInstall
  '';

  meta = {
    description = "Modern, native GUI tool for relational databases (pinned build)";
    homepage = "https://tableplus.com";
    platforms = pkgs.lib.platforms.darwin;
  };
}
