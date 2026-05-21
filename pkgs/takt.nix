{ pkgs }:
pkgs.buildNpmPackage {
  pname = "takt";
  version = "unstable-2026-05-15";

  src = pkgs.fetchFromGitHub {
    owner = "nrslib";
    repo = "takt";
    rev = "598bf88d504f3963cd21fea5a70665b1c482cf5b";
    hash = "sha256-FjwU+evHoqoMKvl6M2+ucmcrnix6FLH4lwkxu7tVI28=";
  };

  npmDepsHash = "sha256-fLbB77Q8AJ24qnS5+t2t0WTAG8hhjIubU4oTtK1+Uk8=";

  meta = {
    description = "Agent orchestration framework";
    homepage = "https://github.com/nrslib/takt";
  };
}
