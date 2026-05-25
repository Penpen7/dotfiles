{
  description = "Standalone neovim configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixpkgs-unstable";
  };
  outputs =
    { nixpkgs, ... }:
    let
      systems = [
        "aarch64-darwin"
        "x86_64-darwin"
        "x86_64-linux"
        "aarch64-linux"
      ];
      forEachSystem = nixpkgs.lib.genAttrs systems;
    in
    {
      packages = forEachSystem (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ (import ./plugins).overlays.default ];
            config.allowUnfree = true;
          };
          nvim = pkgs.callPackage ./nvim.nix { };
        in
        {
          inherit nvim;
          default = nvim;
        }
      );
    };
}
