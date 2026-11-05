{ pkgs }:
pkgs.buildNpmPackage {
  pname = "takt";
  version = "unstable-2026-11-05";

  src = pkgs.fetchFromGitHub {
    owner = "nrslib";
    repo = "takt";
    rev = "3c0b0c0167d10e2feab0f6d5cd530a95687106cf";
    hash = "sha256-fnK5QmH5ia3+JKKUx5oBbNIQOCs2LWJQf9ZpptttVOc=";
  };

  npmDepsFetcherVersion = 2;
  npmDepsHash = "sha256-QQAENtLpBGOPOsKXHxibujlBV71boxVofdDxHWDyOFM=";

  # playwright の postinstall がビルド時にブラウザをダウンロードしようとして失敗するため抑止
  PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = "1";
  PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";

  meta = {
    description = "Agent orchestration framework";
    homepage = "https://github.com/nrslib/takt";
  };
}
