{ pkgs }:
pkgs.vimUtils.buildVimPlugin {
  name = "tig-explorer.vim";
  src = pkgs.fetchFromGitHub {
    owner = "iberianpig";
    repo  = "tig-explorer.vim";
    rev   = "c134fa56ad46a5ff78fcb87c8e10c8cf8ec85b0c";
    hash  = "sha256-X+++SPMYTNl3/waFiJ0ZAElZa8+r/XqlV56BFegwBdM=";
  };
}
