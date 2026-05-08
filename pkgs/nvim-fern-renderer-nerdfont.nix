{ pkgs }:
pkgs.vimUtils.buildVimPlugin {
  name = "fern-renderer-nerdfont.vim";
  src = pkgs.fetchFromGitHub {
    owner = "lambdalisue";
    repo  = "fern-renderer-nerdfont.vim";
    rev   = "325629c68eb543229715b68920fbcb92b206beb6";
    hash  = "sha256-bcFIyPHxdckmmEGSCr9F5hLGTENF+KgRoz2BK49rGv4=";
  };
}
