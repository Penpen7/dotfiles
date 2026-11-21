{ pkgs }:
pkgs.buildNpmPackage {
  pname = "takt";
  version = "unstable-2026-11-20";

  src = pkgs.fetchFromGitHub {
    owner = "nrslib";
    repo = "takt";
    rev = "5993255885bb69a50e4fb5adff659abda7dc4c91";
    hash = "sha256-+zYYYIfP0OJKkMv/DEaSndbJ0b6JLmEWe86mTdC7b2U=";
  };

  npmDepsFetcherVersion = 2;
  npmDepsHash = "sha256-Sk0r3aePlNl5T+0lT/h46cXloe9NViunUFTMR3ERchs=";

  # playwright の postinstall がビルド時にブラウザをダウンロードしようとして失敗するため抑止
  PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = "1";
  PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";

  meta = {
    description = "Agent orchestration framework";
    homepage = "https://github.com/nrslib/takt";
  };
}
