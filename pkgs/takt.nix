{ pkgs }:
pkgs.buildNpmPackage {
  pname = "takt";
  version = "unstable-2026-10-16";

  src = pkgs.fetchFromGitHub {
    owner = "nrslib";
    repo = "takt";
    rev = "ff20f3b3b1263972a5710b0c8084aead02ae001c";
    hash = "sha256-Qo05wCTjHdcjdLfvQUBvjxhP7D7q4PynR4xVCxAk4Dk=";
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
