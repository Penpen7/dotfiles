{ pkgs }:
pkgs.buildNpmPackage {
  pname = "takt";
  version = "unstable-2026-10-04";

  src = pkgs.fetchFromGitHub {
    owner = "nrslib";
    repo = "takt";
    rev = "2878636df998ea730c4ae8f41d8df9bf8c7ee40d";
    hash = "sha256-EvfJm7sakrclw0uzuAUHvr3yEybjSSR9Y7dJBAFQC14=";
  };

  npmDepsFetcherVersion = 2;
  npmDepsHash = "sha256-v5acGqY5l4q70MrwUmmcmONfwNHH+KDuKQJvuSllsx0=";

  # playwright の postinstall がビルド時にブラウザをダウンロードしようとして失敗するため抑止
  PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = "1";
  PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";

  meta = {
    description = "Agent orchestration framework";
    homepage = "https://github.com/nrslib/takt";
  };
}
