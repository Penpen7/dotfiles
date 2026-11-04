{ pkgs }:
pkgs.buildNpmPackage {
  pname = "takt";
  version = "unstable-2026-11-04";

  src = pkgs.fetchFromGitHub {
    owner = "nrslib";
    repo = "takt";
    rev = "2089161eed59b5d5553343f222808d4fc312eb9d";
    hash = "sha256-2LSv+eQtxO/NuArVpo+Fa/ilQQxE8/WGdoM5499F+6c=";
  };

  npmDepsFetcherVersion = 2;
  npmDepsHash = "sha256-xGDrmf+t6D6hZwA1y3Qme+81Vo5mFNS+IXmPjRQfI8Q=";

  # playwright の postinstall がビルド時にブラウザをダウンロードしようとして失敗するため抑止
  PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = "1";
  PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";

  meta = {
    description = "Agent orchestration framework";
    homepage = "https://github.com/nrslib/takt";
  };
}
