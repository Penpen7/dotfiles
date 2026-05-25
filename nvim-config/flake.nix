{
  description = "Standalone neovim configuration";

  inputs.nixpkgs.url = "github:nixos/nixpkgs?ref=nixpkgs-unstable";

  outputs =
    { nixpkgs, ... }:
    let
      system = "aarch64-darwin";
      overlays = [ (import ./plugins).overlays.default ];
      pkgs = import nixpkgs {
        inherit system overlays;
        config.allowUnfree = true;
      };
    in
    {
      packages.${system} = {
        nvim = pkgs.callPackage ./nvim.nix { };
        default = pkgs.callPackage ./nvim.nix { };
      };
    };
}
