{ pkgs }:
pkgs.tmuxPlugins.tmux-powerline.overrideAttrs (_: {
  version = "unstable-2026-09-14";
  src = pkgs.fetchFromGitHub {
    owner = "erikw";
    repo = "tmux-powerline";
    rev = "c9e142fda99307f82145ef322b8d9611af431ca8";
    hash = "sha256-0N+5VgwWTUwq33akcD2BE3EezZUhm5pyMWxJEDQk3Ak=";
  };
})
