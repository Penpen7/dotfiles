{ pkgs }:
pkgs.buildNpmPackage {
  pname = "takt";
  version = "unstable-2026-11-01";

  src = pkgs.fetchFromGitHub {
    owner = "nrslib";
    repo = "takt";
    rev = "1c52e0c46c434f760557116e8ad327bcfa28cc1b";
    hash = "sha256-3l9eDM7k/KvQnSNty2Bnv7wfoHSTq9xtKJBqeJx1Rqs=";
  };

  npmDepsFetcherVersion = 2;
  npmDepsHash = "sha256-cRX3bwxvWOxuDoSZs9yNt034NuPK2PtTflf4aeeioY8=";

  # playwright の postinstall がビルド時にブラウザをダウンロードしようとして失敗するため抑止
  PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = "1";
  PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";

  meta = {
    description = "Agent orchestration framework";
    homepage = "https://github.com/nrslib/takt";
  };
}
