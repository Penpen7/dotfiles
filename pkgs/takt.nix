{ pkgs }:
pkgs.buildNpmPackage {
  pname = "takt";
  version = "unstable-2026-09-11";

  src = pkgs.fetchFromGitHub {
    owner = "nrslib";
    repo = "takt";
    rev = "5af72b7aeac4d4cf4e13db6982088e0eb37e123c";
    hash = "sha256-lcHZVis35hTL5kWyw62Wi8q51kSbZ22RKAI0+IIKhvQ=";
  };

  npmDepsFetcherVersion = 2;
  npmDepsHash = "sha256-yZjURxNnbsBoJKOKm5/u4Nr0+jFOeafnCUKrktK0RAY=";

  # playwright の postinstall がビルド時にブラウザをダウンロードしようとして失敗するため抑止
  PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = "1";
  PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";

  meta = {
    description = "Agent orchestration framework";
    homepage = "https://github.com/nrslib/takt";
  };
}
