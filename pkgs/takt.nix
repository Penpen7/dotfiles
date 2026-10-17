{ pkgs }:
pkgs.buildNpmPackage {
  pname = "takt";
  version = "unstable-2026-10-16";

  src = pkgs.fetchFromGitHub {
    owner = "nrslib";
    repo = "takt";
    rev = "c87caaba01c09436c89935c54687670d7b94e23b";
    hash = "sha256-5njNzsESrdlH3qMec8mykwBGW0skg5aN/UnT5Fw2Bos=";
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
