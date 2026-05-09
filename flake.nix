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

    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nix-darwin,
      nix-vscode-extensions,
      rust-overlay,
    }:
    let
      system = "aarch64-darwin";
      username = "naoki";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          nix-vscode-extensions.overlays.default
          rust-overlay.overlays.default
          (import ./pkgs).overlays.default
        ];
      };
    in
    {
      homeConfigurations = {
        work = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit username; };
          modules = [ ./config/home-manager/profile/work ];
        };
        personal = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit username; };
          modules = [ ./config/home-manager/profile/personal ];
        };
      };
      darwinConfigurations = {
        work = nix-darwin.lib.darwinSystem {
          specialArgs = { inherit self username; };
          modules = [ ./config/nix-darwin/profile/work ];
        };
        personal = nix-darwin.lib.darwinSystem {
          specialArgs = { inherit self username; };
          modules = [ ./config/nix-darwin/profile/personal ];
        };
      };
      formatter.aarch64-darwin = pkgs.nixfmt-rfc-style;
    };
}
