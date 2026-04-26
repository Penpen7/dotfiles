{
  nixpkgs.hostPlatform = "aarch64-darwin";
  system.stateVersion = 5;
  nix.enable = false;
  security.pam.services.sudo_local.touchIdAuth = true
}
