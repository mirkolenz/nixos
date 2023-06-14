{
  description = "nixos";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixpkgs-unstable";
    };
    nixpkgs-nixos = {
      url = "github:nixos/nixpkgs/nixos-23.05";
    };
    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager-nixos = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs-nixos";
    };
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
    };
    systems = {
      url = "github:nix-systems/default";
    };
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vscode-server = {
      url = "github:nix-community/nixos-vscode-server";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware = {
      url = "github:nixos/nixos-hardware";
    };
    nix-index-database = {
      url = "github:mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixneovim = {
      url = "github:nixneovim/nixneovim";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
      inputs.nixneovimplugins.follows = "nixneovimplugins";
    };
    nixneovimplugins = {
      url = "github:nixneovim/nixneovimplugins";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    poetry2nix = {
      url = "github:nix-community/poetry2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mlenz-ssh-keys = {
      url = "https://github.com/mirkolenz.keys";
      flake = false;
    };
    texmf = {
      url = "github:mirkolenz/texmf";
      flake = false;
    };
    gitignore = {
      url = "https://www.toptal.com/developers/gitignore/api/macos,linux,windows,visualstudiocode";
      flake = false;
    };
    macchina = {
      url = "github:macchina-cli/macchina/v6.1.8";
      flake = false;
    };
    bibtex2cff = {
      url = "github:anselmoo/bibtex2cff/v0.2.0";
      flake = false;
    };
    bibtexbrowser = {
      url = "github:monperrus/bibtexbrowser";
      flake = false;
    };
  };

  outputs = inputs @ {
    self,
    darwin,
    flake-parts,
    home-manager,
    home-manager-nixos,
    nixos-generators,
    nixos-hardware,
    nixpkgs,
    nixpkgs-nixos,
    vscode-server,
    systems,
    ...
  }: let
    defaults = {pkgs, ...}: {
      imports = [
        ./overlays
      ];
      nixpkgs.config = {
        allowUnfree = true;
      };
      # change in `./home/default.nix` as well
      _module.args = {
        flakeInputs = inputs;
        extras = {
          dummyPackage = pkgs.writeShellScriptBin "dummy" ":";
          stateVersion = "23.05";
        };
      };
    };
  in
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = import systems;
      perSystem = {
        pkgs,
        system,
        lib,
        ...
      }: {
        formatter = pkgs.alejandra;
        # https://github.com/LnL7/nix-darwin/issues/613#issuecomment-1485325805
        apps = let
          flags = ["--impure" "--no-write-lock-file"];
          mkBuilder = builder:
            pkgs.writeShellApplication {
              name = "builder";
              text = ''
                set -x #echo on
                REBUILD_TYPE=''${1:-switch}
                exec ${builder} --flake ${self} ${builtins.toString flags} "$REBUILD_TYPE" "''${@:2}"
              '';
            };
        in {
          # system builder
          default = let
            emptyDarwin = darwin.lib.darwinSystem {
              inherit system;
              modules = [];
            };
            builder =
              if pkgs.stdenv.isDarwin
              then "${emptyDarwin.system}/sw/bin/darwin-rebuild"
              else pkgs.lib.getExe pkgs.nixos-rebuild;
          in {
            type = "app";
            program = lib.getExe (mkBuilder builder);
          };
          # home-manager builder
          home = let
            builder = pkgs.lib.getExe home-manager.packages.${system}.default;
          in {
            type = "app";
            program = lib.getExe (mkBuilder builder);
          };
        };
        legacyPackages = {
          homeConfigurations = {
            # edit in `./home/default.nix` as well
            mlenz = home-manager.lib.homeManagerConfiguration {
              inherit pkgs;
              modules = [
                defaults
                ./home/mlenz
                inputs.nix-index-database.hmModules.nix-index
                inputs.nixneovim.nixosModules.default
              ];
            };
          };
        };
      };
      flake = {
        packages = let
          generatorFormats = {
            # https://github.com/nix-community/nixos-generators/blob/master/formats/sd-aarch64-installer.nix
            "custom-sd" = {
              imports = [
                "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
              ];
              formatAttr = "sdImage";
            };
            # https://github.com/nix-community/nixos-generators/blob/master/formats/install-iso.nix
            "custom-iso" = {
              imports = [
                "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
              ];
              formatAttr = "isoImage";
            };
          };
        in {
          aarch64-linux = {
            raspi = nixos-generators.nixosGenerate {
              system = "aarch64-linux";
              customFormats = generatorFormats;
              format = "custom-sd";
              modules = [
                defaults
                nixos-hardware.nixosModules.raspberry-pi-4
                ./installer/raspi.nix
              ];
            };
            iso = nixos-generators.nixosGenerate {
              system = "aarch64-linux";
              customFormats = generatorFormats;
              format = "custom-iso";
              modules = [
                defaults
                ./installer/iso.nix
              ];
            };
          };
          x86_64-linux = {
            iso = nixos-generators.nixosGenerate {
              system = "x86_64-linux";
              customFormats = generatorFormats;
              format = "custom-iso";
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
          orbstack = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = [
              defaults
              home-manager.nixosModules.home-manager
              vscode-server.nixosModule
              ./hosts/orbstack
            ];
          };
          homeserver = nixpkgs-nixos.lib.nixosSystem {
            system = "x86_64-linux";
            modules = [
              defaults
              home-manager-nixos.nixosModules.home-manager
              nixos-hardware.nixosModules.common-pc-ssd
              nixos-hardware.nixosModules.common-cpu-intel-cpu-only
              nixos-hardware.nixosModules.common-gpu-amd
              nixos-hardware.nixosModules.common-hidpi
              ./hosts/homeserver
            ];
          };
          raspi = nixpkgs-nixos.lib.nixosSystem {
            system = "aarch64-linux";
            modules = [
              defaults
              home-manager-nixos.nixosModules.home-manager
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
              nixos-hardware.nixosModules.common-gpu-intel-disable
              nixos-hardware.nixosModules.common-gpu-nvidia
              nixos-hardware.nixosModules.common-hidpi
              ./hosts/macbook-nixos
            ];
          };
        };
        darwinConfigurations = {
          mirkos-macbook = darwin.lib.darwinSystem {
            system = "x86_64-darwin";
            modules = [
              defaults
              home-manager.darwinModules.home-manager
              ./hosts/mirkos-macbook
            ];
          };
        };
      };
    };
}
