{ pkgs }:
pkgs.buildNpmPackage {
  pname = "takt";
  version = "unstable-2026-09-29";

  src = pkgs.fetchFromGitHub {
    owner = "nrslib";
    repo = "takt";
    rev = "9700156b88a8d75345487c4308d54aee96b835b0";
    hash = "sha256-dQvTD9FX+4hHQdXBTwtfDwLZN6lavlleyAvuCl7Zklw=";
  };

  npmDepsFetcherVersion = 2;
  npmDepsHash = "sha256-ZJLRLM2LRGNRrfMEEjbNSUdNPbfskBOrNxSgkpnuBrU=";

  # playwright の postinstall がビルド時にブラウザをダウンロードしようとして失敗するため抑止
  PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = "1";
  PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";

  meta = {
    description = "Agent orchestration framework";
    homepage = "https://github.com/nrslib/takt";
  };
}
