{ pkgs }:
pkgs.buildNpmPackage {
  pname = "takt";
  version = "unstable-2026-10-19";

  src = pkgs.fetchFromGitHub {
    owner = "nrslib";
    repo = "takt";
    rev = "09da7c73130a537cb666ac720ef99b68d9a51665";
    hash = "sha256-WE9J05rVGd1Eo3Tco6wOl8yI3Z4vdAnv1L44RmxIgCk=";
  };

  npmDepsFetcherVersion = 2;
  npmDepsHash = "sha256-K2Euvxo7JiZjM933YWt5JTo0xIpc5bKcnelxuAcQVQg=";

  # playwright の postinstall がビルド時にブラウザをダウンロードしようとして失敗するため抑止
  PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = "1";
  PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";

  meta = {
    description = "Agent orchestration framework";
    homepage = "https://github.com/nrslib/takt";
  };
}
