{ pkgs }:
pkgs.buildNpmPackage {
  pname = "takt";
  version = "unstable-2026-09-25";

  src = pkgs.fetchFromGitHub {
    owner = "nrslib";
    repo = "takt";
    rev = "2714f58386318d8855113e81bd742dbf6c8c467c";
    hash = "sha256-X+kXFNHPz49owCQjVsj8CNDOeaagp3Hg1JevcuaCf4A=";
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
