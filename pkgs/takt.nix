{ pkgs }:
pkgs.buildNpmPackage {
  pname = "takt";
  version = "unstable-2026-11-12";

  src = pkgs.fetchFromGitHub {
    owner = "nrslib";
    repo = "takt";
    rev = "ef90945f9b7860f7dc7cfbb0747706ee54b77e36";
    hash = "sha256-SJ/xwZVvf1hIOOM2OyUJ1qdf5XJ3y6+51Q0vc3h2uA8=";
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
