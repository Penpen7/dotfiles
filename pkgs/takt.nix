{ pkgs }:
pkgs.buildNpmPackage {
  pname = "takt";
  version = "unstable-2026-10-10";

  src = pkgs.fetchFromGitHub {
    owner = "nrslib";
    repo = "takt";
    rev = "4ff2396a8803c0fca4662aef9286d86c2f349a77";
    hash = "sha256-enGXmihPM7K0BLbPx6pt66gnZXYvnLxb8WLsTXwRcZY=";
  };

  npmDepsFetcherVersion = 2;
  npmDepsHash = "sha256-oB16lEFVotN+VcaSn6va/hVGzSCKl5KON+Fj2MCfvno=";

  # playwright の postinstall がビルド時にブラウザをダウンロードしようとして失敗するため抑止
  PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = "1";
  PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";

  meta = {
    description = "Agent orchestration framework";
    homepage = "https://github.com/nrslib/takt";
  };
}
