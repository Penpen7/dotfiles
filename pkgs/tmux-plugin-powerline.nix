{ pkgs }:
pkgs.tmuxPlugins.tmux-powerline.overrideAttrs (_: {
  version = "unstable-2026-10-08";
  src = pkgs.fetchFromGitHub {
    owner = "erikw";
    repo = "tmux-powerline";
    rev = "67e21efaeb560443c741e240b74ce7f3995c765d";
    hash = "sha256-gdJ/cZfCByLlf5qnjcODuITZMCUtSFxXMo4tvoeuBto=";
  };
})
