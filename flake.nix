{
  description = "nixos";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-22.11";
    };
    nixpkgs-unstable = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };
    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vscode-server = {
      url = "github:msteen/nixos-vscode-server";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware";
    };
    nixvim = {
      url = "github:pta2002/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ nixpkgs, home-manager, darwin, nixos-generators, vscode-server, nixpkgs-unstable, ... }:
  let
    defaults = { pkgs, ... }: {
      nixpkgs.config.allowUnfree = true;
      # https://github.com/nix-community/home-manager/issues/1538
      _module.args = {
        extras = {
          inherit inputs;
          unstable = import nixpkgs-unstable {
            inherit (pkgs.stdenv.targetPlatform) system;
            config.allowUnfree = true;
          };
          username = "mlenz";
          stateVersion = "22.11";
        };
      };
    };
  in
  {
    # packages = {
    #   aarch64-linux = {
    #     raspi = nixos-generators.nixosGenerate {
    #       system = "aarch64-linux";
    #       format = "sd-aarch64";
    #       modules = [ ];
    #     };
    #   };
    # };
    nixosConfigurations = {
      "vm" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          defaults
          home-manager.nixosModules.home-manager
          vscode-server.nixosModule
          ./platforms/nixos.nix
          ./hosts/vm
          ./users
        ];
      };
      "homeserver" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          defaults
          home-manager.nixosModules.home-manager
          ./platforms/nixos.nix
          ./hosts/homeserver
          ./users
        ];
      };
    };
    darwinConfigurations = {
      "Mirkos-Mac" = darwin.lib.darwinSystem {
        system = "x86_64-darwin";
        modules = [
          defaults
          home-manager.darwinModules.home-manager
          ./platforms/darwin.nix
          ./hosts/macbook
          ./users
        ];
      };
    };
  };
}
