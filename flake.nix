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
    nixpkgs-linux-stable,
    nixpkgs-linux-unstable,
    nixpkgs-darwin-stable,
    nixpkgs-darwin-unstable,
    home-manager,
    home-manager-linux-stable,
    home-manager-linux-unstable,
    home-manager-darwin-stable,
    home-manager-darwin-unstable,
    nix-darwin-stable,
    nix-darwin-unstable,
    nixos-generators,
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

    defaults = {lib, ...}: {
      nixpkgs = {
        config = import ./nixpkgs-config.nix;
        overlays = import ./overlays inputs;
      };
      _module.args = _moduleArgs // {inherit moduleArgNames;};
    };
    mkHomeDefaults = userLogin: {lib, ...}: {
      targets.genericLinux.enable = true;
      _module.args = {
        user.login = lib.mkForce userLogin;
        osConfig = {};
      };
    };
    userLogins = ["mlenz" "lenz" "mirkolenz" "mirkol"];
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
          then nix-darwin-unstable.packages.${system}.default
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
          home = mkBuilder home-manager-linux-unstable.packages.${system}.default;
        };
        legacyPackages.homeConfigurations = lib.genAttrs userLogins (userLogin:
          home-manager-linux-unstable.lib.homeManagerConfiguration {
            inherit pkgs;
            extraSpecialArgs = specialArgs;
            modules = [
              defaults
              (mkHomeDefaults userLogin)
              ./home/mlenz
            ];
          });
      };
      flake = {
        lib = import ./lib nixpkgs.lib;
        packages = {
          aarch64-linux.installer-raspi = nixos-generators.nixosGenerate {
            inherit specialArgs;
            system = "aarch64-linux";
            customFormats = import ./installer/formats.nix nixpkgs-linux-stable;
            format = "custom-sd";
            modules = [
              defaults
              ./installer/raspi.nix
            ];
          };
          aarch64-linux.installer-iso = nixos-generators.nixosGenerate {
            inherit specialArgs;
            system = "aarch64-linux";
            customFormats = import ./installer/formats.nix nixpkgs-linux-stable;
            format = "custom-iso";
            modules = [
              defaults
              ./installer/iso.nix
            ];
          };
          x86_64-linux.installer-iso = nixos-generators.nixosGenerate {
            inherit specialArgs;
            system = "x86_64-linux";
            customFormats = import ./installer/formats.nix nixpkgs-linux-stable;
            format = "custom-iso";
            modules = [
              defaults
              ./installer/iso.nix
            ];
          };
        };
        nixosConfigurations = {
          vm = nixpkgs-linux-unstable.lib.nixosSystem {
            inherit specialArgs;
            system = "x86_64-linux";
            modules = [
              defaults
              home-manager-linux-unstable.nixosModules.home-manager
              ./hosts/vm
            ];
          };
          orbstack = nixpkgs-linux-unstable.lib.nixosSystem {
            inherit specialArgs;
            system = "x86_64-linux";
            modules = [
              defaults
              home-manager-linux-unstable.nixosModules.home-manager
              ./hosts/orbstack
            ];
          };
          macpro = nixpkgs-linux-stable.lib.nixosSystem {
            inherit specialArgs;
            system = "x86_64-linux";
            modules = [
              defaults
              home-manager-linux-stable.nixosModules.home-manager
              ./hosts/macpro
            ];
          };
          raspi = nixpkgs-linux-stable.lib.nixosSystem {
            inherit specialArgs;
            system = "aarch64-linux";
            modules = [
              defaults
              home-manager-linux-stable.nixosModules.home-manager
              ./hosts/raspi
            ];
          };
          macbook-nixos = nixpkgs-linux-unstable.lib.nixosSystem {
            inherit specialArgs;
            system = "x86_64-linux";
            modules = [
              defaults
              home-manager-linux-unstable.nixosModules.home-manager
              ./hosts/macbook-nixos
            ];
          };
          macbook-legacy = nixpkgs-linux-unstable.lib.nixosSystem {
            inherit specialArgs;
            system = "x86_64-linux";
            modules = [
              defaults
              home-manager-linux-unstable.nixosModules.home-manager
              ./hosts/macbook-legacy
            ];
          };
        };
        darwinConfigurations = {
          mirkos-macbook = nix-darwin-unstable.lib.darwinSystem {
            inherit specialArgs;
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
