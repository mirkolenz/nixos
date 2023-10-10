{
  description = "nixos";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixpkgs-unstable";
    };
    nixpkgs-linux-unstable = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };
    nixpkgs-linux-stable = {
      url = "github:nixos/nixpkgs/nixos-23.05";
    };
    nixpkgs-darwin-stable = {
      url = "github:nixos/nixpkgs/nixpkgs-23.05-darwin";
    };
    nixpkgs-darwin-unstable.follows = "nixpkgs";
    nix-darwin-stable = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs-darwin-stable";
    };
    nix-darwin-unstable = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs-darwin-unstable";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager-linux-stable = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs-linux-stable";
    };
    home-manager-linux-unstable = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-linux-unstable";
    };
    home-manager-darwin-stable = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs-darwin-stable";
    };
    home-manager-darwin-unstable = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-darwin-unstable";
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
    makejinja = {
      url = "github:mirkolenz/makejinja/v2";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    arguebuf = {
      url = "github:recap-utr/arguebuf-python/v2";
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
    bibtex2cff = {
      url = "github:anselmoo/bibtex2cff/v0.2.1";
      flake = false;
    };
    bibtexbrowser = {
      url = "github:monperrus/bibtexbrowser";
      flake = false;
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nixpkgs-linux-stable,
    nixpkgs-linux-unstable,
    nixpkgs-darwin-stable,
    nixpkgs-darwin-unstable,
    home-manager,
    home-manager-linux-stable,
    home-manager-linux-unstable,
    home-manager-darwin-stable,
    home-manager-darwin-unstable,
    flake-parts,
    systems,
    nix-darwin-stable,
    nix-darwin-unstable,
    nixos-generators,
    nixos-hardware,
    vscode-server,
    ...
  }: let
    defaults = {
      pkgs,
      lib,
      ...
    }: {
      nixpkgs = {
        config = import ./nixpkgs-config.nix;
        overlays = import ./nixpkgs-overlays.nix inputs;
      };
      # change in `./home/default.nix` as well
      _module.args = let
        inherit (pkgs.stdenv.targetPlatform) system;
      in {
        flakeInputs = inputs;
        # https://www.reddit.com/r/NixOS/comments/qikgub/how_to_use_different_channels_in_a_flake_to/
        pkgsStable =
          if pkgs.stdenv.isDarwin
          then
            import nixpkgs-darwin-stable {
              inherit system;
              config = import ./nixpkgs-config.nix;
            }
          else
            import nixpkgs-linux-stable {
              inherit system;
              config = import ./nixpkgs-config.nix;
            };
        pkgsUnstable =
          if pkgs.stdenv.isDarwin
          then
            import nixpkgs-darwin-unstable {
              inherit system;
              config = import ./nixpkgs-config.nix;
            }
          else
            import nixpkgs-linux-unstable {
              inherit system;
              config = import ./nixpkgs-config.nix;
            };
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
        _module.args.pkgs = import nixpkgs {
          inherit system;
          config = import ./nixpkgs-config.nix;
          overlays = import ./nixpkgs-overlays.nix inputs;
        };
        formatter = pkgs.alejandra;
        # https://github.com/LnL7/nix-darwin/issues/613#issuecomment-1485325805
        apps = let
          flags = ["--impure" "--no-write-lock-file"];
          mkBuilder = builder:
            pkgs.writeShellApplication {
              name = "builder";
              text = ''
                set -x #echo on
                exec ${lib.getExe builder} --flake ${self} ${builtins.toString flags} "''${1:-switch}" "''${@:2}"
              '';
            };
        in {
          # system builder
          default = let
            builder =
              if pkgs.stdenv.isDarwin
              then nix-darwin-unstable.packages.${system}.default
              else pkgs.nixos-rebuild;
          in {
            type = "app";
            program = lib.getExe (mkBuilder builder);
          };
          # home-manager builder
          home = {
            type = "app";
            program = lib.getExe (mkBuilder home-manager-linux-unstable.packages.${system}.default);
          };
        };
        legacyPackages = {
          # edit in `./home/default.nix` as well
          homeConfigurations =
            lib.genAttrs
            ["mlenz" "lenz" "mirkolenz" "mirkol"]
            (username:
              home-manager-linux-unstable.lib.homeManagerConfiguration {
                inherit pkgs;
                modules = [
                  defaults
                  {
                    targets.genericLinux.enable = true;
                    _module.args = {
                      inherit username;
                      osConfig = {};
                    };
                  }
                  ./home/mlenz
                  inputs.nix-index-database.hmModules.nix-index
                  inputs.nixneovim.nixosModules.default
                ];
              });
        };
      };
      flake = {
        packages = let
          generatorFormats = {
            # https://github.com/nix-community/nixos-generators/blob/master/formats/sd-aarch64-installer.nix
            "custom-sd" = {
              imports = [
                "${nixpkgs-linux-stable}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
              ];
              formatAttr = "sdImage";
            };
            # https://github.com/nix-community/nixos-generators/blob/master/formats/install-iso.nix
            "custom-iso" = {
              imports = [
                "${nixpkgs-linux-stable}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
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
          vm = nixpkgs-linux-unstable.lib.nixosSystem {
            system = "x86_64-linux";
            modules = [
              defaults
              home-manager-linux-unstable.nixosModules.home-manager
              vscode-server.nixosModule
              ./hosts/vm
            ];
          };
          orbstack = nixpkgs-linux-unstable.lib.nixosSystem {
            system = "x86_64-linux";
            modules = [
              defaults
              home-manager-linux-unstable.nixosModules.home-manager
              vscode-server.nixosModule
              ./hosts/orbstack
            ];
          };
          macpro = nixpkgs-linux-stable.lib.nixosSystem {
            system = "x86_64-linux";
            modules = [
              defaults
              home-manager-linux-stable.nixosModules.home-manager
              nixos-hardware.nixosModules.common-pc-ssd
              nixos-hardware.nixosModules.common-cpu-intel-cpu-only
              nixos-hardware.nixosModules.common-gpu-amd
              nixos-hardware.nixosModules.common-hidpi
              ./hosts/macpro
            ];
          };
          raspi = nixpkgs-linux-stable.lib.nixosSystem {
            system = "aarch64-linux";
            modules = [
              defaults
              home-manager-linux-stable.nixosModules.home-manager
              nixos-hardware.nixosModules.raspberry-pi-4
              ./hosts/raspi
            ];
          };
          macbook-nixos = nixpkgs-linux-unstable.lib.nixosSystem {
            system = "x86_64-linux";
            modules = [
              defaults
              home-manager-linux-unstable.nixosModules.home-manager
              nixos-hardware.nixosModules.common-pc-laptop-ssd
              nixos-hardware.nixosModules.common-cpu-intel
              nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
              nixos-hardware.nixosModules.common-hidpi
              ./hosts/macbook-nixos
            ];
          };
        };
        darwinConfigurations = {
          mirkos-macbook = nix-darwin-unstable.lib.darwinSystem {
            system = "x86_64-darwin";
            modules = [
              defaults
              home-manager-darwin-unstable.darwinModules.home-manager
              ./hosts/mirkos-macbook
            ];
          };
        };
      };
    };
}
