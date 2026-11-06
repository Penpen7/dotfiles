{ pkgs }:
pkgs.buildNpmPackage {
  pname = "takt";
  version = "unstable-2026-11-06";

  src = pkgs.fetchFromGitHub {
    owner = "nrslib";
    repo = "takt";
    rev = "d00c3dc7341912303d618aba00d70398c29343c5";
    hash = "sha256-0Mlj3iCydxgR7VuntiO0aZCarIXmf6yEeRZhsyS8Sx4=";
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
