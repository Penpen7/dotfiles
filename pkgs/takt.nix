{ pkgs }:
pkgs.buildNpmPackage {
  pname = "takt";
  version = "unstable-2026-07-11";

  src = pkgs.fetchFromGitHub {
    owner = "nrslib";
    repo = "takt";
    rev = "104bade085c4a551c559d2e85fe37c0bf29f599a";
    hash = "sha256-FKHv8sEimrFGDLNqRuIvJZyqqIEFpzWXLRLEtO/A3vY=";
  };

  npmDepsHash = "sha256-vwufmx6b6EpBEDvzbaz70LVb7YGq2Lz4Ahh/cv9gOwM=";

  # playwright の postinstall がビルド時にブラウザをダウンロードしようとして失敗するため抑止
  PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = "1";
  PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";

  meta = {
    description = "Agent orchestration framework";
    homepage = "https://github.com/nrslib/takt";
  };
}
