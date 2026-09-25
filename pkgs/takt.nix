{ pkgs }:
pkgs.buildNpmPackage {
  pname = "takt";
  version = "unstable-2026-09-24";

  src = pkgs.fetchFromGitHub {
    owner = "nrslib";
    repo = "takt";
    rev = "48ff26628b1ff3b4d1b3baa88e2a5b3c8b899fd3";
    hash = "sha256-FYfQtvh+ANMvFISCu7QAbn0WljqACSPKZ+rcsa/K9bE=";
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
