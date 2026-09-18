{ pkgs }:
pkgs.buildNpmPackage {
  pname = "takt";
  version = "unstable-2026-09-17";

  src = pkgs.fetchFromGitHub {
    owner = "nrslib";
    repo = "takt";
    rev = "c9e762803eb350aeea23dcf6d6a7382d3d1398ec";
    hash = "sha256-cDBk9fJA0vDhrf/+qxJcfiTTGeh9+fVaZXDMwLNq+E0=";
  };

  npmDepsFetcherVersion = 2;
  npmDepsHash = "sha256-6APCg0C1Vq90qPXUrNI/6/gR20xO8WYKvci5zcC2JiY=";

  # playwright の postinstall がビルド時にブラウザをダウンロードしようとして失敗するため抑止
  PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = "1";
  PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";

  meta = {
    description = "Agent orchestration framework";
    homepage = "https://github.com/nrslib/takt";
  };
}
