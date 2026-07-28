{ pkgs }:
pkgs.buildNpmPackage {
  pname = "takt";
  version = "unstable-2026-07-28";

  src = pkgs.fetchFromGitHub {
    owner = "nrslib";
    repo = "takt";
    rev = "146e5b3e39ebd7628e16503105e024d4c5a99d97";
    hash = "sha256-Q2BBm3vPINSP8/XAJsprXswDhHe2o3ZH1paOchFmpNY=";
  };

  npmDepsHash = "sha256-FYJuEaSSCc6LAvnuCpSDj/t+gTvrUT7/0KMyh+D25xQ=";

  # playwright の postinstall がビルド時にブラウザをダウンロードしようとして失敗するため抑止
  PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = "1";
  PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";

  meta = {
    description = "Agent orchestration framework";
    homepage = "https://github.com/nrslib/takt";
  };
}
