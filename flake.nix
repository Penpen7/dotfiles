{
    description = "A flake to provision my environment";

    inputs = {
        nixpkgs = {
            url = "github:nixos/nixpkgs?ref=nixpkgs-unstable";
        };

        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        nix-darwin = {
            url = "github:LnL7/nix-darwin";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = {
        self,
        nixpkgs,
        home-manager,
        nix-darwin,
    }:
    let
      system = "aarch64-darwin";
      pkgs = nixpkgs.legacyPackages.${system};
    in
      {
        homeConfigurations."naoki" = home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            modules = [./config/home-manager/home.nix];
        };
        darwinConfigurations = {
            "uehara-mac" = nix-darwin.lib.darwinSystem {
                specialArgs = { inherit self; };
                modules = [
                   ./config/nix-darwin/configuration.nix
                ];
            };
        };
    };
}
