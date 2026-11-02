{ pkgs }:
pkgs.buildNpmPackage {
  pname = "takt";
  version = "unstable-2026-11-01";

  src = pkgs.fetchFromGitHub {
    owner = "nrslib";
    repo = "takt";
    rev = "7247bb81296569814354e6b72cb4eb1db718f3d6";
    hash = "sha256-n456f39+aUtJYjy4DHzRnhr02Hn7MQegTVu9abRBKYE=";
  };

  npmDepsFetcherVersion = 2;
  npmDepsHash = "sha256-cRX3bwxvWOxuDoSZs9yNt034NuPK2PtTflf4aeeioY8=";

  # playwright の postinstall がビルド時にブラウザをダウンロードしようとして失敗するため抑止
  PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = "1";
  PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";

  meta = {
    description = "Agent orchestration framework";
    homepage = "https://github.com/nrslib/takt";
  };
}
