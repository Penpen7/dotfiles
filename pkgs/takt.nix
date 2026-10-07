{ pkgs }:
pkgs.buildNpmPackage {
  pname = "takt";
  version = "unstable-2026-10-06";

  src = pkgs.fetchFromGitHub {
    owner = "nrslib";
    repo = "takt";
    rev = "94cd580deff312a0e1f89ee7fa8af9d90ff06cfb";
    hash = "sha256-GwgsAWbAHL9Bm1N9BtwJCwgtaagKqSYxkAXXCwmDdKo=";
  };

  npmDepsFetcherVersion = 2;
  npmDepsHash = "sha256-yMLxVzh01XymtOFywvuoMLcEb2KiBtDAkKErrDQZyxI=";

  # playwright の postinstall がビルド時にブラウザをダウンロードしようとして失敗するため抑止
  PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = "1";
  PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";

  meta = {
    description = "Agent orchestration framework";
    homepage = "https://github.com/nrslib/takt";
  };
}
