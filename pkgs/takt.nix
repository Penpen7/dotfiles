{ pkgs }:
pkgs.buildNpmPackage {
  pname = "takt";
  version = "unstable-2026-07-04";

  src = pkgs.fetchFromGitHub {
    owner = "nrslib";
    repo = "takt";
    rev = "0a7f3cfa1d849022889edbef6cee4ba28396f5a4";
    hash = "sha256-3BoZauhAA5uifn+xZADM2hBmPZP7meu0sMnpTNd1B24=";
  };

  npmDepsHash = "sha256-zX2WyeyC+zgLTRhR8xLA74eQYVPxw4MPS0m7WRnOW4E=";

  meta = {
    description = "Agent orchestration framework";
    homepage = "https://github.com/nrslib/takt";
  };
}
