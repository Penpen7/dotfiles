{ pkgs }:
pkgs.buildNpmPackage {
  pname = "takt";
  version = "unstable-2026-10-09";

  src = pkgs.fetchFromGitHub {
    owner = "nrslib";
    repo = "takt";
    rev = "6a96d22cd816676ea9c81c4d230396cc45e7a7a1";
    hash = "sha256-/TQAWfKvNIWTQqbH022ppsy9siUfdzRR/nBQMs39caA=";
  };

  npmDepsFetcherVersion = 2;
  npmDepsHash = "sha256-ibTWa6O7SeQL9cR8iHp0snGP8DzeuE0XuCdW2dEDcLA=";

  # playwright の postinstall がビルド時にブラウザをダウンロードしようとして失敗するため抑止
  PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = "1";
  PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";

  meta = {
    description = "Agent orchestration framework";
    homepage = "https://github.com/nrslib/takt";
  };
}
