{ pkgs }:
pkgs.buildNpmPackage {
  pname = "takt";
  version = "unstable-2026-11-22";

  src = pkgs.fetchFromGitHub {
    owner = "nrslib";
    repo = "takt";
    rev = "4f6963958fe0cac33b47754bbfa489afd943819d";
    hash = "sha256-4MOQKKXMOTf8ZpKmSvZTo/Zd1s5ofB9/X7EEguNlqqE=";
  };

  npmDepsFetcherVersion = 2;
  npmDepsHash = "sha256-Sk0r3aePlNl5T+0lT/h46cXloe9NViunUFTMR3ERchs=";

  # playwright の postinstall がビルド時にブラウザをダウンロードしようとして失敗するため抑止
  PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = "1";
  PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";

  meta = {
    description = "Agent orchestration framework";
    homepage = "https://github.com/nrslib/takt";
  };
}
