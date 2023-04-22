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
    mlenz-ssh-keys = {
      url = "https://github.com/mirkolenz.keys";
      flake = false;
    };
    gitignore = {
      url = "https://www.toptal.com/developers/gitignore/api/macos,linux,windows,visualstudiocode";
      flake = false;
    };
  };

  outputs = inputs@{ nixpkgs, home-manager, darwin, nixos-generators, vscode-server, nixpkgs-unstable, nixos-hardware, mlenz-ssh-keys, ... }:
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
          dummyPackage = (pkgs.writeShellScriptBin "dummy" ":");
          username = "mlenz";
          stateVersion = "22.11";
        };
      };
    };
  in
  {
    packages = {
      aarch64-linux = {
        raspi = nixos-generators.nixosGenerate {
          system = "aarch64-linux";
          # customFormats = {
          #   "myFormat" = {
          #     imports = [
          #       "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
          #     ];
          #     formatAttr = "sdImage";
          #   };
          # };
          format = "sd-aarch64-installer";
          modules = [
            defaults
            ./installer/raspi.nix
          ];
        };
      };
      x86_64-linux = {
        iso = nixos-generators.nixosGenerate {
          system = "x86_64-linux";
          format = "install-iso";
          modules = [
            defaults
            ./installer/iso.nix
          ];
        };
      };
    };
    nixosConfigurations = {
      vm = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          defaults
          home-manager.nixosModules.home-manager
          vscode-server.nixosModule
          ./hosts/vm
        ];
      };
      homeserver = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          defaults
          home-manager.nixosModules.home-manager
          nixos-hardware.nixosModules.common-pc-ssd
          nixos-hardware.nixosModules.common-cpu-intel-cpu-only
          nixos-hardware.nixosModules.common-gpu-amd
          nixos-hardware.nixosModules.common-hidpi
          ./hosts/homeserver
        ];
      };
      raspi = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
          defaults
          home-manager.nixosModules.home-manager
          nixos-hardware.nixosModules.raspberry-pi-4
          ./hosts/raspi
        ];
      };
      macbook-nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          defaults
          home-manager.nixosModules.home-manager
          nixos-hardware.nixosModules.common-pc-laptop-ssd
          nixos-hardware.nixosModules.common-cpu-intel-cpu-only
          nixos-hardware.nixosModules.common-gpu-intel
          nixos-hardware.nixosModules.common-gpu-nvidia-disable
          nixos-hardware.nixosModules.common-hidpi
          ./hosts/macbook-nixos
        ];
      };
    };
    darwinConfigurations = {
      macbook = darwin.lib.darwinSystem {
        system = "x86_64-darwin";
        modules = [
          defaults
          home-manager.darwinModules.home-manager
          ./hosts/macbook
        ];
      };
    };
  };
}
