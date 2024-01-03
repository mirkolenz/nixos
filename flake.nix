{
  description = "nixos";

  inputs = {
    # Nixpkgs
    nixpkgs. url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-linux-stable.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-linux-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-darwin-stable.url = "github:nixos/nixpkgs/nixpkgs-23.11-darwin";
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
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs-linux-stable";
    };
    home-manager-linux-unstable = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-linux-unstable";
    };
    home-manager-darwin-stable = {
      url = "github:nix-community/home-manager/release-23.11";
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
      url = "github:nix-community/nixvim/nixos-23.11";
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
    flocken,
    ...
  }: let
    getOs = system: nixpkgs.lib.last (nixpkgs.lib.splitString "-" system);

    extendLib = input:
      input.lib.extend (nixpkgs.lib.composeManyExtensions [
        self.overlays.lib
        flocken.overlays.lib
      ]);

    # available during import
    specialArgs = {
      inherit inputs;
      stateVersion = "23.11";
      stateVersionDarwin = 4;
      stableVersion = "23.11";
      unstableVersion = "24.05";
    };

    # can be overriden in module
    moduleArgs = {
      user = {
        name = "Mirko Lenz";
        mail = "mirko@mirkolenz.com";
        login = "mlenz";
        id = 1000;
        sshKeys = flocken.lib.githubSshKeys {
          user = "mirkolenz";
          sha256 = "0f52mwv3ja24q1nz65aig8id2cpvnm0w92f9xdc80xn3qg3ji374";
        };
      };
    };

    homeModule = {
      pkgs,
      lib,
      ...
    }: {
      imports = [./home/mlenz];
      _module.args = moduleArgs;
      programs.nixvim = mkVimConfig {inherit pkgs lib;};
    };

    standaloneHomeModule = {pkgs, ...}: {
      _module.args.osConfig = {};
      nixpkgs = {
        config = import ./nixpkgs-config.nix;
        overlays = import ./overlays inputs;
      };
      targets.genericLinux.enable = pkgs.stdenv.isLinux;
    };

    systemModule = {...}: {
      nixpkgs = {
        config = import ./nixpkgs-config.nix;
        overlays = import ./overlays inputs;
      };
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = specialArgs;
        users.mlenz.imports = [
          homeModule
        ];
      };
    };

    mkLinuxSystem = hostName: {
      channel,
      system,
    }: let
      lib = extendLib inputs."nixpkgs-linux-${channel}";
    in
      lib.nixosSystem {
        inherit specialArgs system lib;
        modules = [
          systemModule
          inputs."home-manager-linux-${channel}".nixosModules.home-manager
          ./system/linux
          ./hosts/${hostName}
          {
            _module.args = moduleArgs;
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
        lib = extendLib inputs."nix-darwin-${channel}".inputs.nixpkgs;
        modules = [
          systemModule
          inputs."home-manager-darwin-${channel}".darwinModules.home-manager
          ./system/darwin
          ./hosts/${hostName}
          {
            _module.args = moduleArgs;
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
        lib = extendLib inputs.nixos-generators.inputs.nixpkgs;
        customFormats = import ./installer/formats.nix inputs.nixos-generators.inputs.nixpkgs;
        modules = [
          {_module.args = moduleArgs;}
          installerModule
        ];
      };

    mkHomeConfig = userName: {
      channel,
      system,
    }: let
      os = getOs system;
      hmInput = inputs."home-manager-${os}-${channel}";
    in
      hmInput.lib.homeManagerConfiguration {
        lib = extendLib hmInput.inputs.nixpkgs;
        pkgs = import hmInput.inputs.nixpkgs {
          inherit system;
        };
        extraSpecialArgs = specialArgs;
        modules = [
          standaloneHomeModule
          homeModule
          {
            _module.args.user.login = userName;
          }
        ];
      };

    mkDefaultHomeConfig = system: userName:
      mkHomeConfig userName {
        inherit system;
        channel = "unstable";
      };

    mkVimConfig = args @ {
      pkgs,
      lib,
    }:
      import ./vim (
        moduleArgs // specialArgs // args
      );
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
                sudo ${lib.getExe pkgs.nixos-rebuild} "$@"
              '';
            };
        mkNixVim = input:
          input.legacyPackages.${system}.makeNixvim (
            mkVimConfig {
              lib = extendLib input.inputs.nixpkgs;
              pkgs = import input.inputs.nixpkgs {
                inherit system;
                config = import ./nixpkgs-config.nix;
              };
            }
          );
      in {
        formatter = pkgs.alejandra;
        packages = {
          default = self'.packages.system;
          system = mkBuilder systemBuilder;
          home = mkBuilder inputs.home-manager-linux-unstable.packages.${system}.default;
          vim = mkNixVim inputs.nixvim-unstable;
          vim-stable = mkNixVim inputs.nixvim-linux-stable;
        };
        legacyPackages.homeConfigurations =
          lib.genAttrs
          ["mlenz" "lenz" "mirkolenz" "mirkol"]
          (mkDefaultHomeConfig system);
      };
      flake = {
        lib = import ./lib nixpkgs.lib;
        overlays = {
          lib = final: prev: {
            custom = import ./lib prev;
          };
        };
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
