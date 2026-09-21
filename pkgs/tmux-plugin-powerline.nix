{ pkgs }:
pkgs.tmuxPlugins.tmux-powerline.overrideAttrs (_: {
  version = "unstable-2026-09-20";
  src = pkgs.fetchFromGitHub {
    owner = "erikw";
    repo = "tmux-powerline";
    rev = "ab137fb8a7f3b93d8b123d960be2d04649d3ef65";
    hash = "sha256-3wPyLhsL7vSBHT6fWQIIKt/GYxlu81ZEtxlLocGamJE=";
  };
})
