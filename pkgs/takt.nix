{ pkgs }:
pkgs.buildNpmPackage {
  pname = "takt";
  version = "unstable-2026-10-08";

  src = pkgs.fetchFromGitHub {
    owner = "nrslib";
    repo = "takt";
    rev = "e827e811ded43a33c98488254015fd02c56f9ad5";
    hash = "sha256-aXIw13t6J5GTvKEahVtwwtGWMZ0kXbw//0Dd6hUaaMc=";
  };

  npmDepsFetcherVersion = 2;
  npmDepsHash = "sha256-rlot2szGOsML4Ny5DM8itTxZz7tjCCyLO8GhXmWlVCc=";

  # playwright の postinstall がビルド時にブラウザをダウンロードしようとして失敗するため抑止
  PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = "1";
  PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";

  meta = {
    description = "Agent orchestration framework";
    homepage = "https://github.com/nrslib/takt";
  };
}
