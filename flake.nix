{
  description = "NixOS / Home Manager / nix-darwin configuration files (@mirkolenz)";

  # state dir: ~/.local/share/nix/trusted-settings.json
  nixConfig = {
    allow-import-from-derivation = false;
    extra-substituters = [
      "https://mirkolenz.cachix.org"
      "https://install.determinate.systems"
    ];
    extra-trusted-public-keys = [
      "mirkolenz.cachix.org-1:R0dgCJ93t33K/gncNbKgUdJzwgsYVXeExRsZNz5jpho="
      "cache.flakehub.com-3:hJuILl5sVK4iKm86JzgdXW12Y2Hwd5G07qKtHTOcDCM="
    ];
  };

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-linux-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-linux-stable.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-darwin-stable.url = "github:nixos/nixpkgs/nixpkgs-25.11-darwin";

    # Small helpers
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:nixos/nixos-hardware";
    determinate.url = "github:determinatesystems/determinate";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Third-party modules
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
      };
    };

    # My own
    flocken = {
      url = "github:mirkolenz/flocken/v2";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
      };
    };
    quadlet-nix = {
      url = "github:mirkolenz/quadlet-nix/v1";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
      };
    };
    texmf = {
      url = "github:mirkolenz/texmf";
      flake = false;
    };
    bibliography = {
      url = "github:mirkolenz/bibliography";
      flake = false;
    };

    # Utils
    vscode-server = {
      url = "github:nix-community/nixos-vscode-server";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-converter = {
      url = "github:theobori/nix-converter/1.0.0"; # autoupdate
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko/v1.11.0"; # autoupdate
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-sweep = {
      url = "github:jzbor/nix-sweep/v0.8.0"; # autoupdate
      inputs.nixpkgs.follows = "nixpkgs";
    };
    opencode = {
      url = "github:anomalyco/opencode/v1.1.12"; # autoupdate
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plist-manager = {
      url = "github:sushydev/nix-plist-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    cosmic-manager = {
      url = "github:heitoraugustoln/cosmic-manager";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
        flake-parts.follows = "flake-parts";
      };
    };
    nixos-wsl = {
      url = "github:nix-community/nixos-wsl/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    apple-t2-iso = {
      url = "github:t2linux/nixos-t2-iso";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        nixos-hardware.follows = "nixos-hardware";
      };
    };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake {
      inherit inputs;
      specialArgs = {
        lib' = import ./lib inputs;
      };
    } ./flake;
}
