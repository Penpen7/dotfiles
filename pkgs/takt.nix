{ pkgs }:
pkgs.buildNpmPackage {
  pname = "takt";
  version = "unstable-2026-10-23";

  src = pkgs.fetchFromGitHub {
    owner = "nrslib";
    repo = "takt";
    rev = "01fd9d97232c7d2c168823b570fa19ee34f67fbc";
    hash = "sha256-2oiejI0vez/yKD2HdD3TmQetVSy6jeS4mNl+PLPEzUs=";
  };

  npmDepsFetcherVersion = 2;
  npmDepsHash = "sha256-dibzBenV2NkU7fNVAmkQ0Ya3+72QH3wBmfjS6lmNm+M=";

  # playwright の postinstall がビルド時にブラウザをダウンロードしようとして失敗するため抑止
  PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = "1";
  PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";

  meta = {
    description = "Agent orchestration framework";
    homepage = "https://github.com/nrslib/takt";
  };
}
