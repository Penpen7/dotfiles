{ pkgs }:
pkgs.buildNpmPackage {
  pname = "takt";
  version = "unstable-2026-11-09";

  src = pkgs.fetchFromGitHub {
    owner = "nrslib";
    repo = "takt";
    rev = "4c6f4b615ca2c5c13eedcc95e229776407a3e14a";
    hash = "sha256-qZYRw1zCqeMJ36oRlCCO8zZTv3gffffp5gc/NvpifuY=";
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
