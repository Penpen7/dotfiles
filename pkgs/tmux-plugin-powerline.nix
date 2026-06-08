{ pkgs }:
pkgs.tmuxPlugins.tmux-powerline.overrideAttrs (_: {
  version = "unstable-2026-06-02";
  src = pkgs.fetchFromGitHub {
    owner = "erikw";
    repo = "tmux-powerline";
    rev = "9d6852878dcdf1b15d461d61b06ffc100e8802c3";
    hash = "sha256-TuIw1Vu7SH9kNrJ1EHxsqMjpBIVI558ZeOtC41w42ic=";
  };
})
