{ pkgs }:
pkgs.buildNpmPackage {
  pname = "takt";
  version = "unstable-2026-08-29";

  src = pkgs.fetchFromGitHub {
    owner = "nrslib";
    repo = "takt";
    rev = "1faa2b59bd6ee7bc969f719bfb7593cd97cdca5f";
    hash = "sha256-J7I3muQdPMWpMsqQsEHJWGKOU+U7ZqxWQ6/77TwgjIo=";
  };

  npmDepsFetcherVersion = 2;
  npmDepsHash = "sha256-qybgfUbOIfhTSyFHMIQs2P3t6mbhQEfV2RCJ1tGM6wg=";

  # playwright の postinstall がビルド時にブラウザをダウンロードしようとして失敗するため抑止
  PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = "1";
  PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";

  meta = {
    description = "Agent orchestration framework";
    homepage = "https://github.com/nrslib/takt";
  };
}
