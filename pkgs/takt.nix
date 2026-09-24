{ pkgs }:
pkgs.buildNpmPackage {
  pname = "takt";
  version = "unstable-2026-09-24";

  src = pkgs.fetchFromGitHub {
    owner = "nrslib";
    repo = "takt";
    rev = "0222b98d9a53be1c72798a03459c0670c88b8a3f";
    hash = "sha256-XNtSGcKjBsDikKsvyl1zOikKKvaQcNTtarkiks4kVb0=";
  };

  npmDepsFetcherVersion = 2;
  npmDepsHash = "sha256-m2tC5Y+DL1sopI3GJ9aP2JFplBUsLawqN9pflAL10yU=";

  # playwright の postinstall がビルド時にブラウザをダウンロードしようとして失敗するため抑止
  PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = "1";
  PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";

  meta = {
    description = "Agent orchestration framework";
    homepage = "https://github.com/nrslib/takt";
  };
}
