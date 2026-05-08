{ pkgs }:
pkgs.vimUtils.buildVimPlugin {
  name = "glyph-palette.vim";
  src = pkgs.fetchFromGitHub {
    owner = "lambdalisue";
    repo  = "glyph-palette.vim";
    rev   = "675f0ad64e2c4b823bffc1907d469deefaf6e3bd";
    hash  = "sha256-y3pykCEynYGvjrQKzcYJsiuVOci+y2SNh0ZOg2xV8yU=";
  };
}
