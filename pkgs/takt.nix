{ pkgs }:
pkgs.buildNpmPackage {
  pname = "takt";
  version = "unstable-2026-10-30";

  src = pkgs.fetchFromGitHub {
    owner = "nrslib";
    repo = "takt";
    rev = "c2d264bf1f7683c476191a2a574b4ff9bbfda38b";
    hash = "sha256-ID1t1cv89dAAJu4cN/jAtpLJr6OlVHtHtJ4RWByEz0I=";
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
