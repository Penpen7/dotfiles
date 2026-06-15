{ pkgs }:
pkgs.buildNpmPackage {
  pname = "takt";
  version = "unstable-2026-06-15";

  src = pkgs.fetchFromGitHub {
    owner = "nrslib";
    repo = "takt";
    rev = "73674951658660d901521f6724188131ef05fc04";
    hash = "sha256-krLJ2AlPJdp0YN6yW5QvTuvVL4Trln3XIgzhhWySJBg=";
  };

  npmDepsHash = "sha256-JHyXH1zs8Acdsl5huU7jmkyQk0rbr1Fmj6IjOirqajs=";

  meta = {
    description = "Agent orchestration framework";
    homepage = "https://github.com/nrslib/takt";
  };
}
