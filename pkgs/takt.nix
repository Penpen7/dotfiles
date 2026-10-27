{ pkgs }:
pkgs.buildNpmPackage {
  pname = "takt";
  version = "unstable-2026-10-27";

  src = pkgs.fetchFromGitHub {
    owner = "nrslib";
    repo = "takt";
    rev = "f9e82929854d1b1a50cdfc234e013e0f6a4f50e6";
    hash = "sha256-GqhN66kEicWDIT0KavWbF+/blgZnjtfu0HDekapo6O4=";
  };

  npmDepsFetcherVersion = 2;
  npmDepsHash = "sha256-17j8yFn8GDlCBqJmS8XmFbZou55ccOch30SQ70N42/Y=";

  # playwright の postinstall がビルド時にブラウザをダウンロードしようとして失敗するため抑止
  PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = "1";
  PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";

  meta = {
    description = "Agent orchestration framework";
    homepage = "https://github.com/nrslib/takt";
  };
}
