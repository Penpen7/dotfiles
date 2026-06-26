{ pkgs }:
pkgs.buildNpmPackage {
  pname = "takt";
  version = "unstable-2026-06-25";

  src = pkgs.fetchFromGitHub {
    owner = "nrslib";
    repo = "takt";
    rev = "8211f56bbfca1480d1e597cf15f4488b963525f6";
    hash = "sha256-n2e/qg2Av0zPWHXZvgQBA4o3oZ3qdoTNpRSaDH/bubQ=";
  };

  npmDepsHash = "sha256-APdqM4wVbd3zHJdj9oIntTgtYat2YjNguWcVCj4d2VQ=";

  meta = {
    description = "Agent orchestration framework";
    homepage = "https://github.com/nrslib/takt";
  };
}
