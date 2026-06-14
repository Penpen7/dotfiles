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

    nvim-config = {
      url = "path:./nvim-config";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    browser-nix = {
      url = "github:Penpen7/browser.nix";
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
      nvim-config,
      browser-nix,
    }:
    let
      darwinSystem = "aarch64-darwin";
      forEachSystem = nixpkgs.lib.genAttrs (builtins.attrNames nvim-config.packages);
      overlays = [
        nix-vscode-extensions.overlays.default
        rust-overlay.overlays.default
        browser-nix.overlays.default
        (import ./pkgs).overlays.default
        (_: _: { nvim = nvim-config.packages.${darwinSystem}.nvim; })
      ];
      pkgs = import nixpkgs {
        system = darwinSystem;
        inherit overlays;
      };
      mkDarwinSystem =
        profile:
        nix-darwin.lib.darwinSystem {
          specialArgs = { inherit self; };
          modules = [
            home-manager.darwinModules.home-manager
            ./config/nix-darwin/profile/${profile}
            {
              nixpkgs.overlays = overlays;
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "bak";
              };
            }
          ];
        };
    in
    {
      darwinConfigurations = {
        work = mkDarwinSystem "work";
        personal = mkDarwinSystem "personal";
      };
      packages = forEachSystem (system: { nvim = nvim-config.packages.${system}.nvim; });
      formatter = forEachSystem (system: (import nixpkgs { inherit system; }).nixfmt);
    };
}
