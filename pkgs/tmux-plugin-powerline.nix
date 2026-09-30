{ pkgs }:
pkgs.tmuxPlugins.tmux-powerline.overrideAttrs (_: {
  version = "unstable-2026-09-29";
  src = pkgs.fetchFromGitHub {
    owner = "erikw";
    repo = "tmux-powerline";
    rev = "495339df47dc6c72b129061a0eeb34a9cffddafc";
    hash = "sha256-IhiMZhdNbrmr03J51vZwhP+F2v8XIOhiztTgzqWHBds=";
  };
})
