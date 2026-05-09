{ pkgs }:
pkgs.tmuxPlugins.open.overrideAttrs (_: {
  version = "unstable-2022-08-22";
  src = pkgs.fetchFromGitHub {
    owner = "tmux-plugins";
    repo = "tmux-open";
    rev = "763d0a852e6703ce0f5090a508330012a7e6788e";
    hash = "sha256-Thii7D21MKodtjn/MzMjOGbJX8BwnS+fQqAtYv8CjPc=";
  };
})
