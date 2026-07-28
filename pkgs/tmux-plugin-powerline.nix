{ pkgs }:
pkgs.tmuxPlugins.tmux-powerline.overrideAttrs (_: {
  version = "unstable-2026-07-27";
  src = pkgs.fetchFromGitHub {
    owner = "erikw";
    repo = "tmux-powerline";
    rev = "6cfa41c7696f0d530450d509b1e07ce3d778bd4b";
    hash = "sha256-+DzP+IjP3SZGdT6o4fhB59gqWFO8sjaezhOq44bpUSo=";
  };
})
