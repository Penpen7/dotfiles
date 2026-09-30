{ pkgs }:
pkgs.buildNpmPackage {
  pname = "takt";
  version = "unstable-2026-09-30";

  src = pkgs.fetchFromGitHub {
    owner = "nrslib";
    repo = "takt";
    rev = "c9a7d63cae02ffa88f1598080a9ba2c5efebf1d9";
    hash = "sha256-V891bPc1smdddMdazJFUasU9nhd96WMufsiPce8StDg=";
  };

  npmDepsFetcherVersion = 2;
  npmDepsHash = "sha256-hh3LHzlPvHYtHTLNlG8wYvuZi8HKIcaVLFB0YtfO3+c=";

  # playwright の postinstall がビルド時にブラウザをダウンロードしようとして失敗するため抑止
  PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = "1";
  PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";

  meta = {
    description = "Agent orchestration framework";
    homepage = "https://github.com/nrslib/takt";
  };
}
