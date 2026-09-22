{ pkgs }:
let
  # バージョンを固定して直接ダウンロードする。
  # 各バージョンの変更履歴は下記ページを参照:
  #   https://cleanshot.com/changelog
  version = "4.8.11";
in
pkgs.stdenvNoCC.mkDerivation {
  pname = "cleanshot";
  inherit version;

  src = pkgs.fetchurl {
    url = "https://updates.getcleanshot.com/v3/CleanShot-X-${version}.dmg";
    hash = "sha256-KYr7PQhe5jQ9rpVLoqdCm9YT5q2elCyPeQCGiM6xGoE=";
  };

  nativeBuildInputs = [ pkgs._7zz ];

  # CleanShot X の dmg は APFS 形式のため undmg では展開できない。
  # _7zz なら APFS DMG も扱えるので、これで展開して CleanShot X.app を取り出す。
  unpackPhase = ''
    runHook preUnpack
    7zz x "$src" -o_dmg
    # 7zz は拡張属性を "<path>:<xattr名>" というファイルとして書き出してしまう。
    # このゴミが残ったままだとコード署名のシールが壊れて起動できなくなるので削除する。
    find _dmg -name '*:com.apple.*' -delete
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall
    app=$(find _dmg -maxdepth 3 -name 'CleanShot X.app' -type d | head -n1)
    if [ -z "$app" ]; then
      echo "CleanShot X.app not found in extracted DMG" >&2
      exit 1
    fi
    mkdir -p "$out/Applications/CleanShot X.app"
    cp -R "$app/." "$out/Applications/CleanShot X.app"
    runHook postInstall
  '';

  meta = {
    description = "Screenshot and screen recording tool for macOS (pinned version)";
    homepage = "https://cleanshot.com";
    platforms = pkgs.lib.platforms.darwin;
  };
}
