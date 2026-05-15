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
      usernames = {
        work = "naoki.uehara";
        personal = "naoki";
      };
      overlays = [
        nix-vscode-extensions.overlays.default
        rust-overlay.overlays.default
        (import ./pkgs).overlays.default
      ];
      pkgs = import nixpkgs {
        inherit system;
        inherit overlays;
      };
    in
    {
      darwinConfigurations = {
        work = nix-darwin.lib.darwinSystem {
          specialArgs = {
            inherit self;
            username = usernames.work;
          };
          modules = [
            home-manager.darwinModules.home-manager
            ./config/nix-darwin/profile/work
            {
              nixpkgs.overlays = overlays;
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = {
                  username = usernames.work;
                };
                users = {
                  "${usernames.work}" = {
                    imports = [ ./config/home-manager/profile/work ];
                  };
                };
              };
            }
          ];
        };
        personal = nix-darwin.lib.darwinSystem {
          specialArgs = {
            inherit self;
            username = usernames.personal;
          };
          modules = [
            home-manager.darwinModules.home-manager
            ./config/nix-darwin/profile/personal
            {
              nixpkgs.overlays = overlays;
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = {
                  username = usernames.personal;
                };
                users = {
                  "${usernames.personal}" = {
                    imports = [ ./config/home-manager/profile/personal ];
                  };
                };
              };
            }
          ];
        };
      };
      formatter.aarch64-darwin = pkgs.nixfmt;
    };
}
