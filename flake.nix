{
  description = "nixos";

  inputs = {
    # Nixpkgs
    nixpkgs. url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-linux-stable.url = "github:nixos/nixpkgs/nixos-23.05";
    nixpkgs-linux-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-darwin-stable.url = "github:nixos/nixpkgs/nixpkgs-23.05-darwin";
    nixpkgs-darwin-unstable.follows = "nixpkgs";

    # Small helpers
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default";
    nixos-hardware.url = "github:nixos/nixos-hardware";

    # Nix Darwin
    nix-darwin-stable = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs-darwin-stable";
    };
    nix-darwin-unstable = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs-darwin-unstable";
    };

    # Home Manager
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

    # My own
    flocken = {
      url = "github:mirkolenz/flocken/v2";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    makejinja = {
      url = "github:mirkolenz/makejinja/v2";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.poetry2nix.follows = "poetry2nix";
      inputs.flocken.follows = "flocken";
    };
    arguebuf = {
      url = "github:recap-utr/arguebuf-python/v2";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.poetry2nix.follows = "poetry2nix";
      inputs.flocken.follows = "flocken";
    };
    mlenz-ssh-keys = {
      url = "https://github.com/mirkolenz.keys";
      flake = false;
    };
    texmf = {
      url = "github:mirkolenz/texmf";
      flake = false;
    };

    # Utils
    poetry2nix = {
      url = "github:nix-community/poetry2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs-linux-stable";
    };
    vscode-server = {
      url = "github:nix-community/nixos-vscode-server";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim-unstable = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim-linux-stable = {
      url = "github:nix-community/nixvim/nixos-23.05";
      inputs.nixpkgs.follows = "nixpkgs-linux-stable";
    };

    # Non-flakes
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
    flake-parts,
    systems,
    nixpkgs,
    ...
  }: let
    # available during import
    _specialArgs = {inherit inputs;};
    specialArgNames = builtins.attrNames _specialArgs;
    specialArgs = _specialArgs // {inherit specialArgNames;};

    # can be overriden in module
    _moduleArgs = {
      extras = {
        stateVersion = "23.05";
        user = {
          name = "Mirko Lenz";
          mail = "mirko@mirkolenz.com";
          login = "mlenz";
          id = 1000;
        };
      };
    };
    moduleArgNames = builtins.attrNames _moduleArgs;

    defaultModule = {lib, ...}: {
      nixpkgs = {
        config = import ./nixpkgs-config.nix;
        overlays = import ./overlays inputs;
      };
      _module.args = _moduleArgs // {inherit moduleArgNames;};
    };
    mkHomeModule = userLogin: {lib, ...}: {
      targets.genericLinux.enable = true;
      _module.args = {
        user.login = lib.mkForce userLogin;
        osConfig = {};
      };
    };
    userLogins = ["mlenz" "lenz" "mirkolenz" "mirkol"];

    mkLinuxSystem = hostName: {
      channel,
      system,
    }:
      inputs."nixpkgs-linux-${channel}".lib.nixosSystem {
        inherit specialArgs system;
        modules = [
          defaultModule
          inputs."home-manager-linux-${channel}".nixosModules.home-manager
          ./hosts/${hostName}
          {
            networking.hostName = hostName;
          }
        ];
      };

    mkDarwinSystem = hostName: {
      channel,
      system,
      computerName,
    }:
      inputs."nix-darwin-${channel}".lib.darwinSystem {
        inherit specialArgs system;
        modules = [
          defaultModule
          inputs."home-manager-darwin-${channel}".darwinModules.home-manager
          ./hosts/${hostName}
          {
            networking = {
              inherit hostName computerName;
            };
          }
        ];
      };

    mkInstaller = {
      system,
      format,
      installerModule,
    }:
      inputs.nixos-generators.nixosGenerate {
        inherit specialArgs system format;
        customFormats = import ./installer/formats.nix inputs.nixpkgs-linux-stable;
        modules = [
          defaultModule
          installerModule
        ];
      };
  in
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = import systems;
      perSystem = {
        self',
        pkgs,
        system,
        lib,
        ...
      }: let
        buildFlags = ["--impure" "--no-write-lock-file"];
        mkBuilder = builder:
          pkgs.writeShellApplication {
            name = "builder";
            text = ''
              set -x #echo on
              exec ${lib.getExe builder} --flake ${self} ${builtins.toString buildFlags} "''${1:-switch}" "''${@:2}"
            '';
          };
        systemBuilder =
          if pkgs.stdenv.isDarwin
          then inputs.nix-darwin-unstable.packages.${system}.default
          else
            pkgs.writeShellApplication {
              name = "sudo-nixos-rebuild";
              text = ''
                ${self.lib.checkSudo}
                $SUDO ${lib.getExe pkgs.nixos-rebuild} "$@"
              '';
            };
      in {
        _module.args.pkgs = import nixpkgs {
          inherit system;
          config = import ./nixpkgs-config.nix;
        };
        formatter = pkgs.alejandra;
        packages = {
          default = self'.packages.system;
          system = mkBuilder systemBuilder;
          home = mkBuilder inputs.home-manager-linux-unstable.packages.${system}.default;
        };
        legacyPackages.homeConfigurations = lib.genAttrs userLogins (userLogin:
          inputs.home-manager-linux-unstable.lib.homeManagerConfiguration {
            inherit pkgs;
            extraSpecialArgs = specialArgs;
            modules = [
              defaultModule
              (mkHomeModule userLogin)
              ./home/mlenz
            ];
          });
      };
      flake = {
        lib = import ./lib nixpkgs.lib;
        packages = {
          aarch64-linux.installer-raspi = mkInstaller {
            system = "aarch64-linux";
            format = "custom-sd";
            installerModule = ./installer/raspi.nix;
          };
          aarch64-linux.installer-iso = mkInstaller {
            system = "aarch64-linux";
            format = "custom-iso";
            installerModule = ./installer/iso.nix;
          };
          x86_64-linux.installer-iso = mkInstaller {
            system = "x86_64-linux";
            format = "custom-iso";
            installerModule = ./installer/iso.nix;
          };
        };
        nixosConfigurations = builtins.mapAttrs mkLinuxSystem {
          vm = {
            channel = "unstable";
            system = "x86_64-linux";
          };
          orbstack = {
            channel = "unstable";
            system = "x86_64-linux";
          };
          macpro = {
            channel = "stable";
            system = "x86_64-linux";
          };
          raspi = {
            channel = "stable";
            system = "aarch64-linux";
          };
          macbook-9-1 = {
            channel = "unstable";
            system = "x86_64-linux";
          };
          macbook-11-3 = {
            channel = "unstable";
            system = "x86_64-linux";
          };
        };
        darwinConfigurations = builtins.mapAttrs mkDarwinSystem {
          mirkos-macbook = {
            channel = "unstable";
            system = "x86_64-darwin";
            computerName = "Mirkos MacBook";
          };
        };
      };
    };
}
