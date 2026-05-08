{ pkgs }:
pkgs.vimUtils.buildVimPlugin {
  name = "fern-git-status.vim";
  src = pkgs.fetchFromGitHub {
    owner = "lambdalisue";
    repo  = "fern-git-status.vim";
    rev   = "151336335d3b6975153dad77e60049ca7111da8e";
    hash  = "sha256-9N+T/MB+4hKcxoKRwY8F7iwmTsMtNmHCHiVZfcsADcc=";
  };
}
