{ pkgs }:
pkgs.buildNpmPackage {
  pname = "takt";
  version = "unstable-2026-09-15";

  src = pkgs.fetchFromGitHub {
    owner = "nrslib";
    repo = "takt";
    rev = "9f81b9e586fa7ef480e4ebbb7fd5bf01d8468c16";
    hash = "sha256-gICfN+ef/SgQWuc86OKkPvbHJJb3LrSBdTE9jC8gAcQ=";
  };

  npmDepsFetcherVersion = 2;
  npmDepsHash = "sha256-OmVj1+Z+wtw6VbdWTsC+E4d0Pbqf6JaHdE04A2iGYpA=";

  # playwright の postinstall がビルド時にブラウザをダウンロードしようとして失敗するため抑止
  PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = "1";
  PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";

  meta = {
    description = "Agent orchestration framework";
    homepage = "https://github.com/nrslib/takt";
  };
}
