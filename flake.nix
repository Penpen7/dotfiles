{
    description = "A flake to provision my environment";

    inputs = {
        nixpkgs = {
            url = "github:nixos/nixpkgs?ref=nixos-unstable";
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
    }: {
        darwinConfigurations = {
            "uehara-mac" = nix-darwin.lib.darwinSystem {
                modules = [
                   ./config/nix-darwin/configuration.nix 
                ];
            };
        };
    };
}
