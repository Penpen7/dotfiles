{ pkgs }:
pkgs.buildNpmPackage {
  pname = "takt";
  version = "unstable-2026-10-06";

  src = pkgs.fetchFromGitHub {
    owner = "nrslib";
    repo = "takt";
    rev = "5c135df1e8be12e4dbd3df968c9c8614fa74e8c5";
    hash = "sha256-72+yU88xJeVC9/6bohdzzlSSYQz8HguiHk82KJXoUic=";
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
