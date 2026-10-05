{ pkgs }:
pkgs.buildNpmPackage {
  pname = "takt";
  version = "unstable-2026-10-05";

  src = pkgs.fetchFromGitHub {
    owner = "nrslib";
    repo = "takt";
    rev = "b43a6237b7ab83a135ab114a936480089cdb31c1";
    hash = "sha256-F8YYreOGiIHNMP8ydKWlQrRB1BuXvlwIRezbCM9uLVA=";
  };

  npmDepsFetcherVersion = 2;
  npmDepsHash = "sha256-2tiSg+uNmGs/tkYUKe44mFI8ZNbyEs9HZMoHG0XAIHk=";

  # playwright の postinstall がビルド時にブラウザをダウンロードしようとして失敗するため抑止
  PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = "1";
  PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";

  meta = {
    description = "Agent orchestration framework";
    homepage = "https://github.com/nrslib/takt";
  };
}
