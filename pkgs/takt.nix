{ pkgs }:
pkgs.buildNpmPackage {
  pname = "takt";
  version = "unstable-2026-06-08";

  src = pkgs.fetchFromGitHub {
    owner = "nrslib";
    repo = "takt";
    rev = "9a927648e009833929370c53990b7ffc805092e5";
    hash = "sha256-OchjoKpA0HlrMme/5WyfU+wuJpqE9web4STnnbqzT+g=";
  };

  npmDepsHash = "sha256-fLbB77Q8AJ24qnS5+t2t0WTAG8hhjIubU4oTtK1+Uk8=";

  meta = {
    description = "Agent orchestration framework";
    homepage = "https://github.com/nrslib/takt";
  };
}
