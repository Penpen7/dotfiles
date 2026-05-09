{ pkgs }:
pkgs.vimUtils.buildVimPlugin {
  name = "telescope-co-author.nvim";
  src = pkgs.fetchFromGitHub {
    owner = "Penpen7";
    repo = "telescope-co-author.nvim";
    rev = "e0eefc8474230ccdab8a572f099547c2104c388e";
    hash = "sha256-nONZmtOH1l8BMhK0zxWFVQRFp/fnsDxWEZrs7pu+rZc=";
  };
  dependencies = [
    pkgs.vimPlugins.telescope-nvim
    pkgs.vimPlugins.plenary-nvim
  ];
}
