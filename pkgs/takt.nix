{ pkgs }:
pkgs.buildNpmPackage {
  pname = "takt";
  version = "unstable-2026-11-10";

  src = pkgs.fetchFromGitHub {
    owner = "nrslib";
    repo = "takt";
    rev = "aaf72fe0df2d081d359d9932027ea1cd031da9a6";
    hash = "sha256-EA6ph9UPR9ipeUkLU4lyjX6SU2Nu2vmG6afv7BMvH08=";
  };

  npmDepsFetcherVersion = 2;
  npmDepsHash = "sha256-QQAENtLpBGOPOsKXHxibujlBV71boxVofdDxHWDyOFM=";

  # playwright の postinstall がビルド時にブラウザをダウンロードしようとして失敗するため抑止
  PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = "1";
  PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";

  meta = {
    description = "Agent orchestration framework";
    homepage = "https://github.com/nrslib/takt";
  };
}
