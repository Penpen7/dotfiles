{ pkgs }:
pkgs.buildNpmPackage {
  pname = "takt";
  version = "unstable-2026-11-17";

  src = pkgs.fetchFromGitHub {
    owner = "nrslib";
    repo = "takt";
    rev = "7483ead25925504fed76255961e41c4ff7ad62d5";
    hash = "sha256-qKmVeQHDOtdp2koKMKmqkuX8NX4eP7yPHGxUWH7QoCM=";
  };

  npmDepsFetcherVersion = 2;
  npmDepsHash = "sha256-mAZm/MqiIaJBH/ham0+f+9yz1Bj1zClUBIF4CWz7DM0=";

  # playwright の postinstall がビルド時にブラウザをダウンロードしようとして失敗するため抑止
  PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = "1";
  PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";

  meta = {
    description = "Agent orchestration framework";
    homepage = "https://github.com/nrslib/takt";
  };
}
