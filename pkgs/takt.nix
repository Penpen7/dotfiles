{ pkgs }:
pkgs.buildNpmPackage {
  pname = "takt";
  version = "unstable-2026-09-15";

  src = pkgs.fetchFromGitHub {
    owner = "nrslib";
    repo = "takt";
    rev = "88dcf8f4f1122d31a73307b22971a2cc4c57d3d1";
    hash = "sha256-BECHe7ftPSFH/eztoH0y/sm27xd/IkMTZLI1LJw5eB8=";
  };

  npmDepsFetcherVersion = 2;
  npmDepsHash = "sha256-Ru9m3+exwenQuZ0RpWDDodg1JlRMylxCNGIECnbb880=";

  # playwright の postinstall がビルド時にブラウザをダウンロードしようとして失敗するため抑止
  PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = "1";
  PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";

  meta = {
    description = "Agent orchestration framework";
    homepage = "https://github.com/nrslib/takt";
  };
}
