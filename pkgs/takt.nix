{ pkgs }:
pkgs.buildNpmPackage {
  pname = "takt";
  version = "unstable-2026-10-11";

  src = pkgs.fetchFromGitHub {
    owner = "nrslib";
    repo = "takt";
    rev = "3128ef42ed6976f4f014db5f8d808c69b816ecc2";
    hash = "sha256-iuzyXbgzmm97p2oXh9np0nYcSVsamJe48MDgGxU1RvY=";
  };

  npmDepsFetcherVersion = 2;
  npmDepsHash = "sha256-7/KA5l5SlNlaHh9l7++Qkm3BEzCSjiBPAoHkhjVRLnU=";

  # playwright の postinstall がビルド時にブラウザをダウンロードしようとして失敗するため抑止
  PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = "1";
  PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";

  meta = {
    description = "Agent orchestration framework";
    homepage = "https://github.com/nrslib/takt";
  };
}
