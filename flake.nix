{
  description = "NixOS / Home Manager / nix-darwin configuration files (@mirkolenz)";

  # state folder: ~/.local/share/nix/trusted-settings.json
  nixConfig = {
    extra-experimental-features = [
      "nix-command"
      "flakes"
    ];
    # also change in ./system/common/nix.nix
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-linux-stable.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-linux-v2311.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-linux-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-darwin-stable.url = "github:nixos/nixpkgs/nixpkgs-24.05-darwin";
    # https://hydra.nixos.org/job/nixpkgs/nixpkgs-23.11-darwin/texliveFull.x86_64-darwin
    nixpkgs-darwin-v2311.url = "github:nixos/nixpkgs/e13f3602fb31a0985f212ae75d4aadda17ad8c85";
    nixpkgs-darwin-unstable.follows = "nixpkgs";

    # Small helpers
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    systems.url = "github:nix-systems/default";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Nix Darwin
    nix-darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs-linux-stable";
    };
    home-manager-linux-unstable = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-linux-unstable";
    };
    home-manager-darwin-stable = {
      url = "github:nix-community/home-manager/release-24.05";
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
      inputs.flake-parts.follows = "flake-parts";
    };
    arguebuf = {
      url = "github:recap-utr/arguebuf-python/v2";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
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
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
      inputs.nix-darwin.follows = "nix-darwin";
    };
    nixvim-linux-stable = {
      url = "github:nix-community/nixvim/nixos-24.05";
      inputs.nixpkgs.follows = "nixpkgs-linux-stable";
      inputs.home-manager.follows = "home-manager-linux-stable";
      inputs.nix-darwin.follows = "nix-darwin-stable";
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
        systems = import systems;
        imports = [ ./flake-modules ];
      };
}
