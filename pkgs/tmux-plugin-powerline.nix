{ pkgs }:
pkgs.tmuxPlugins.tmux-powerline.overrideAttrs (_: {
  version = "unstable-2026-02-09";
  src = pkgs.fetchFromGitHub {
    owner = "erikw";
    repo  = "tmux-powerline";
    rev   = "d70011158dc389070d6ed7a67b65367206b6ddec";
    hash  = "sha256-0ibtd1gTyr8hJDBsAfmgH3qr0zC0o2Fn0tjN/S+zxgA=";
  };
})
