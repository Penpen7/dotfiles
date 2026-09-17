{ pkgs }:
pkgs.buildNpmPackage {
  pname = "takt";
  version = "unstable-2026-09-17";

  src = pkgs.fetchFromGitHub {
    owner = "nrslib";
    repo = "takt";
    rev = "b2f0b9c471c7930272d4befe87c99088031db3ea";
    hash = "sha256-nBK5WLGCd9GNAD8h9hBinoVZC5zuHGltOu5Tk43gHVg=";
  };

  npmDepsFetcherVersion = 2;
  npmDepsHash = "sha256-6APCg0C1Vq90qPXUrNI/6/gR20xO8WYKvci5zcC2JiY=";

  # playwright の postinstall がビルド時にブラウザをダウンロードしようとして失敗するため抑止
  PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = "1";
  PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";

  meta = {
    description = "Agent orchestration framework";
    homepage = "https://github.com/nrslib/takt";
  };
}
