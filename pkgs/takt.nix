{ pkgs }:
pkgs.buildNpmPackage {
  pname = "takt";
  version = "unstable-2026-06-23";

  src = pkgs.fetchFromGitHub {
    owner = "nrslib";
    repo = "takt";
    rev = "34ff5f7b57fe5311e0f2bcaf6575f78ea65f2a8f";
    hash = "sha256-egfCsmNkiSx/sfWWTdnuLUoB+Lsa+pPz+xlCA4a0oxY=";
  };

  npmDepsHash = "sha256-APdqM4wVbd3zHJdj9oIntTgtYat2YjNguWcVCj4d2VQ=";

  meta = {
    description = "Agent orchestration framework";
    homepage = "https://github.com/nrslib/takt";
  };
}
