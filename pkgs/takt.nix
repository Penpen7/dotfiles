{ pkgs }:
pkgs.buildNpmPackage {
  pname = "takt";
  version = "unstable-2026-09-26";

  src = pkgs.fetchFromGitHub {
    owner = "nrslib";
    repo = "takt";
    rev = "2e4e0206473437182349f285753d0827a3bbe43d";
    hash = "sha256-Vts9beQXjx5Oi72iTrysdxxgghdIBFsygEl86ZQxPL8=";
  };

  npmDepsFetcherVersion = 2;
  npmDepsHash = "sha256-ZJLRLM2LRGNRrfMEEjbNSUdNPbfskBOrNxSgkpnuBrU=";

  # playwright の postinstall がビルド時にブラウザをダウンロードしようとして失敗するため抑止
  PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = "1";
  PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";

  meta = {
    description = "Agent orchestration framework";
    homepage = "https://github.com/nrslib/takt";
  };
}
