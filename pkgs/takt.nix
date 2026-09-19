{ pkgs }:
pkgs.buildNpmPackage {
  pname = "takt";
  version = "unstable-2026-09-18";

  src = pkgs.fetchFromGitHub {
    owner = "nrslib";
    repo = "takt";
    rev = "12e575b9cd4f11d6ecd6442855378832007f5d5c";
    hash = "sha256-oE8VNpFwoNrTx7LZkzvBNRKY99BKyS9pkQ09/bhv9WM=";
  };

  npmDepsFetcherVersion = 2;
  npmDepsHash = "sha256-lOHOYGofCwbMSvnqRfwZNjDeLMFXtKoVFlPXw16gWDQ=";

  # playwright の postinstall がビルド時にブラウザをダウンロードしようとして失敗するため抑止
  PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = "1";
  PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";

  meta = {
    description = "Agent orchestration framework";
    homepage = "https://github.com/nrslib/takt";
  };
}
