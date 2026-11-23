{ pkgs }:
pkgs.buildNpmPackage {
  pname = "takt";
  version = "unstable-2026-11-22";

  src = pkgs.fetchFromGitHub {
    owner = "nrslib";
    repo = "takt";
    rev = "d591bd45df08d3c30286ed4c47fe6509104e945b";
    hash = "sha256-TyAwqMsenUmCfFRu67MA5zJTVunWjX8qLRHycMBWh4U=";
  };

  npmDepsFetcherVersion = 2;
  npmDepsHash = "sha256-wuNotYAoSKFKb8WcPPaozM0eak9k60z47wXf4O6EoZI=";

  # playwright の postinstall がビルド時にブラウザをダウンロードしようとして失敗するため抑止
  PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = "1";
  PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";

  meta = {
    description = "Agent orchestration framework";
    homepage = "https://github.com/nrslib/takt";
  };
}
