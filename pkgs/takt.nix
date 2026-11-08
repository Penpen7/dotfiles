{ pkgs }:
pkgs.buildNpmPackage {
  pname = "takt";
  version = "unstable-2026-11-08";

  src = pkgs.fetchFromGitHub {
    owner = "nrslib";
    repo = "takt";
    rev = "38111fe30921429706420756409305caa883d1e6";
    hash = "sha256-0mpyt7MH1YU1uoo8xFN+7YeLpa3khg/iIqd+RE0LIR4=";
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
