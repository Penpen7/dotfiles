{ pkgs }:
pkgs.buildNpmPackage {
  pname = "takt";
  version = "unstable-2026-10-29";

  src = pkgs.fetchFromGitHub {
    owner = "nrslib";
    repo = "takt";
    rev = "d30382b8439e5c50907856ec543ed4e8a60a418b";
    hash = "sha256-G43hxWhCc4HNsCiHJRHiiCMaNkqlyB1Sx5BYsUxuTPw=";
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
