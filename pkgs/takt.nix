{ pkgs }:
pkgs.buildNpmPackage {
  pname = "takt";
  version = "unstable-2026-10-31";

  src = pkgs.fetchFromGitHub {
    owner = "nrslib";
    repo = "takt";
    rev = "bd933a40805c557a0e136ffd653a4183116f7f23";
    hash = "sha256-VolBvjVY2UfoaBONvgplGFP3Fd3UY5/fJMaXYlEI9cI=";
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
