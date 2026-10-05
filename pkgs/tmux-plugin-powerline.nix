{ pkgs }:
pkgs.tmuxPlugins.tmux-powerline.overrideAttrs (_: {
  version = "unstable-2026-10-02";
  src = pkgs.fetchFromGitHub {
    owner = "erikw";
    repo = "tmux-powerline";
    rev = "54feb8fcb17d71a206440681bb430cfb774aff4d";
    hash = "sha256-Mk+5bIwabTf6ng0PGUgZis447B7DgWGZR20Ji+2V61Y=";
  };
})
