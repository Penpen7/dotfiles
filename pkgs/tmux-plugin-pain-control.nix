{ pkgs }:
pkgs.tmuxPlugins."pain-control".overrideAttrs (_: {
  version = "unstable-2021-08-09";
  src = pkgs.fetchFromGitHub {
    owner = "tmux-plugins";
    repo  = "tmux-pain-control";
    rev   = "32b760f6652f2305dfef0acd444afc311cf5c077";
    hash  = "sha256-2VI9w7Naj9OHF3iuV63Ij4QcYhbrtngyJ3GpeyzIKxs=";
  };
})
