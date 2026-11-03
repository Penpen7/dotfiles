{ pkgs }:
pkgs.buildNpmPackage {
  pname = "takt";
  version = "unstable-2026-11-03";

  src = pkgs.fetchFromGitHub {
    owner = "nrslib";
    repo = "takt";
    rev = "01b4f8245f9e4f3b69577e35fd87a8349872661e";
    hash = "sha256-qeHi7kob2CthZ4w4JYmq2SzhWZQHJp2a2LJsuHZQWvs=";
  };

  npmDepsFetcherVersion = 2;
  npmDepsHash = "sha256-xGDrmf+t6D6hZwA1y3Qme+81Vo5mFNS+IXmPjRQfI8Q=";

  # playwright の postinstall がビルド時にブラウザをダウンロードしようとして失敗するため抑止
  PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = "1";
  PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";

  meta = {
    description = "Agent orchestration framework";
    homepage = "https://github.com/nrslib/takt";
  };
}
