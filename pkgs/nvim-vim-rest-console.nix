{ pkgs }:
pkgs.vimUtils.buildVimPlugin {
  name = "vim-rest-console";
  src = pkgs.fetchFromGitHub {
    owner = "diepm";
    repo = "vim-rest-console";
    rev = "7b407f47185468d1b57a8bd71cdd66c9a99359b2";
    hash = "sha256-Us7LLK/GJsFyIIROGn4y0k8c3yz+Y/X+WWwHcRqL+PQ=";
  };
}
