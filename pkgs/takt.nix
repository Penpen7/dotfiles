{ pkgs }:
pkgs.buildNpmPackage {
  pname = "takt";
  version = "unstable-2026-11-15";

  src = pkgs.fetchFromGitHub {
    owner = "nrslib";
    repo = "takt";
    rev = "aa09c331559d3d9215138671f8bf133a792327af";
    hash = "sha256-daSPUOW80CvnxGnyLW51+n4hpnNfDoEM34TkXrT0Whw=";
  };

  npmDepsFetcherVersion = 2;
  npmDepsHash = "sha256-mAZm/MqiIaJBH/ham0+f+9yz1Bj1zClUBIF4CWz7DM0=";

  # playwright の postinstall がビルド時にブラウザをダウンロードしようとして失敗するため抑止
  PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = "1";
  PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";

  meta = {
    description = "Agent orchestration framework";
    homepage = "https://github.com/nrslib/takt";
  };
}
