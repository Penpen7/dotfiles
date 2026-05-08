{ pkgs }:
pkgs.vimUtils.buildVimPlugin {
  name = "nerdfont.vim";
  src = pkgs.fetchFromGitHub {
    owner = "lambdalisue";
    repo  = "nerdfont.vim";
    rev   = "cc50782ee9580fc70b659cf1ebd55229d94b37ab";
    hash  = "sha256-Eb79rGmFBidT9hdjYZqyxwXynpsipfZopJFabYHimys=";
  };
}
