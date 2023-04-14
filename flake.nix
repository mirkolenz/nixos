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
  };

  outputs = inputs@{ nixpkgs, home-manager, darwin, nixos-generators, vscode-server, ... }: {
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
          home-manager.darwinModules.home-manager
          ./platforms/darwin.nix
          ./hosts/macbook
          ./users
        ];
      };
    };
  };
}
