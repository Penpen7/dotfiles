{ pkgs }:
pkgs.buildNpmPackage {
  pname = "takt";
  version = "unstable-2026-10-27";

  src = pkgs.fetchFromGitHub {
    owner = "nrslib";
    repo = "takt";
    rev = "2802366a03d6d29412665ad19eaa35aa26349289";
    hash = "sha256-oHxd5ODp0nCzEjhAIG0lBPMMUQFlq3STbo0j195gDuo=";
  };

  npmDepsFetcherVersion = 2;
  npmDepsHash = "sha256-4TUEIH49Rd9krsBjB8S1Cs2RrMGgHF2Tsw1Yli3P2PE=";

  # playwright の postinstall がビルド時にブラウザをダウンロードしようとして失敗するため抑止
  PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = "1";
  PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";

  meta = {
    description = "Agent orchestration framework";
    homepage = "https://github.com/nrslib/takt";
  };
}
