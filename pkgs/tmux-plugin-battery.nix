{ pkgs }:
pkgs.tmuxPlugins.battery.overrideAttrs (_: {
  version = "unstable-2025-12-30";
  src = pkgs.fetchFromGitHub {
    owner = "tmux-plugins";
    repo  = "tmux-battery";
    rev   = "43832651ede43f54dcf0588727c1957fe648d57d";
    hash  = "sha256-kyUrJdraDDye8WEBP2RgHN7kHmafToYtLmrMJ9u0f+0=";
  };
})
