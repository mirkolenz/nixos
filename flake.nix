{
  description = "NixOS / Home Manager / nix-darwin configuration files (@mirkolenz)";

  # state dir: ~/.local/share/nix/trusted-settings.json
  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://mirkolenz.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "mirkolenz.cachix.org-1:R0dgCJ93t33K/gncNbKgUdJzwgsYVXeExRsZNz5jpho="
    ];
  };

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-linux-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-linux-stable.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-darwin-unstable.follows = "nixpkgs";
    nixpkgs-darwin-stable.url = "github:nixos/nixpkgs/nixpkgs-25.05-darwin";
    nixpkgs-unstable-small.url = "github:nixos/nixpkgs/nixos-unstable-small";
    nixpkgs-stable-small.url = "github:nixos/nixpkgs/nixos-25.05-small";

    # Small helpers
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    systems.url = "github:nix-systems/default";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Nix Darwin
    nix-darwin-unstable = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs-darwin-unstable";
    };
    nix-darwin-stable = {
      url = "github:nix-darwin/nix-darwin"; # todo: nix-darwin-25.05
      inputs.nixpkgs.follows = "nixpkgs-darwin-stable";
    };

    # Home Manager
    home-manager-linux-unstable = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-linux-unstable";
    };
    home-manager-linux-stable = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs-linux-stable";
    };
    home-manager-darwin-unstable = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-darwin-unstable";
    };
    home-manager-darwin-stable = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs-darwin-stable";
    };

    # NixVim
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
        systems.follows = "systems";
      };
    };
    quadlet-nix = {
      url = "github:mirkolenz/quadlet-nix/v1";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
      };
    };
    arguebuf = {
      url = "github:recap-utr/arguebuf-python/v2";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
        flocken.follows = "flocken";
        pyproject-nix.follows = "pyproject-nix";
        uv2nix.follows = "uv2nix";
        pyproject-build-systems.follows = "pyproject-build-systems";
        treefmt-nix.follows = "treefmt-nix";
        systems.follows = "systems";
      };
    };

    # Python/uv
    pyproject-nix = {
      url = "github:pyproject-nix/pyproject.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    uv2nix = {
      url = "github:pyproject-nix/uv2nix";
      inputs = {
        pyproject-nix.follows = "pyproject-nix";
        nixpkgs.follows = "nixpkgs";
      };
    };
    pyproject-build-systems = {
      url = "github:pyproject-nix/build-system-pkgs";
      inputs = {
        pyproject-nix.follows = "pyproject-nix";
        uv2nix.follows = "uv2nix";
        nixpkgs.follows = "nixpkgs";
      };
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
    nix-github-actions = {
      url = "github:nix-community/nix-github-actions";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-converter = {
      url = "github:theobori/nix-converter";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    angrr = {
      url = "github:linyinfeng/angrr";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
        treefmt-nix.follows = "treefmt-nix";
      };
    };
    cosmic-manager = {
      url = "github:heitoraugustoln/cosmic-manager";
      inputs = {
        nixpkgs.follows = "nixpkgs-linux-unstable";
        home-manager.follows = "home-manager-linux-unstable";
        flake-parts.follows = "flake-parts";
      };
    };
  };

  outputs =
    inputs@{ flake-parts, systems, ... }:
    flake-parts.lib.mkFlake
      {
        inherit inputs;
        specialArgs = {
          lib' = {
            self = import ./lib inputs.nixpkgs.lib;
            flocken = inputs.flocken.lib;
          };
        };
      }
      {
        debug = true;
        systems = import systems;
        imports = [ ./flake-modules ];
      };
}
