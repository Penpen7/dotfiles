{ pkgs }:
pkgs.buildNpmPackage {
  pname = "takt";
  version = "unstable-2026-11-28";

  src = pkgs.fetchFromGitHub {
    owner = "nrslib";
    repo = "takt";
    rev = "1b1e6bb7c509b28f9b00247e334617930d298a3d";
    hash = "sha256-6QrnSfYrEWa3VB2RrOQiMAi+W0Hrs2snvpkr5SyMJ4g=";
  };

  npmDepsFetcherVersion = 2;
  npmDepsHash = "sha256-ln0RRhjaKJBzKlpzX76GKLbJi2nOr5RZPf+1AEuAtj8=";

  # playwright の postinstall がビルド時にブラウザをダウンロードしようとして失敗するため抑止
  PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = "1";
  PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";

  meta = {
    description = "Agent orchestration framework";
    homepage = "https://github.com/nrslib/takt";
  };
}
