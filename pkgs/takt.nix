{ pkgs }:
pkgs.buildNpmPackage {
  pname = "takt";
  version = "unstable-2026-11-14";

  src = pkgs.fetchFromGitHub {
    owner = "nrslib";
    repo = "takt";
    rev = "e331bd5a4ec686d879cf4d04b5a6531aade3138f";
    hash = "sha256-rP9pADUSyGvhyioIdNkxWq+zVA2nOOgGlgqEGaOjk+g=";
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
