{ pkgs }:
pkgs.buildNpmPackage {
  pname = "takt";
  version = "unstable-2026-10-24";

  src = pkgs.fetchFromGitHub {
    owner = "nrslib";
    repo = "takt";
    rev = "43d5582a314f06d1f0e6a43a10382b752511408a";
    hash = "sha256-fzg7RkE9D39yYd8o71J8lrehwtPIUIa5a45WH2XM0QI=";
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
