{
  description = "NixOS / Home Manager / nix-darwin configuration files (@mirkolenz)";

  # state dir: ~/.local/share/nix/trusted-settings.json
  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://mirkolenz.cachix.org"
      "https://cosmic.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "mirkolenz.cachix.org-1:R0dgCJ93t33K/gncNbKgUdJzwgsYVXeExRsZNz5jpho="
      "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="
    ];
  };

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-linux-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-linux-stable.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-darwin-unstable.follows = "nixpkgs";
    nixpkgs-darwin-stable.url = "github:nixos/nixpkgs/nixpkgs-24.11-darwin";
    nixpkgs-texlive.url = "github:nixos/nixpkgs/21645616f604279351551e7c97d26494e273a18c";

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
    nix = {
      url = "github:determinatesystems/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Nix Darwin
    nix-darwin-unstable = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs-darwin-unstable";
    };
    nix-darwin-stable = {
      url = "github:lnl7/nix-darwin/nix-darwin-24.11";
      inputs.nixpkgs.follows = "nixpkgs-darwin-stable";
    };

    # Home Manager
    home-manager-linux-unstable = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-linux-unstable";
    };
    home-manager-linux-stable = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs-linux-stable";
    };
    home-manager-darwin-unstable = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-darwin-unstable";
    };
    home-manager-darwin-stable = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs-darwin-stable";
    };

    # NixVim
    nixvim-linux-unstable = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs-linux-unstable";
      inputs.home-manager.follows = "home-manager-linux-unstable";
      inputs.nix-darwin.follows = "nix-darwin-unstable";
    };
    nixvim-linux-stable = {
      url = "github:nix-community/nixvim/nixos-24.11";
      inputs.nixpkgs.follows = "nixpkgs-linux-stable";
      inputs.home-manager.follows = "home-manager-linux-stable";
      inputs.nix-darwin.follows = "nix-darwin-stable";
    };
    nixvim-darwin-unstable = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs-darwin-unstable";
      inputs.home-manager.follows = "home-manager-darwin-unstable";
      inputs.nix-darwin.follows = "nix-darwin-unstable";
    };
    nixvim-darwin-stable = {
      url = "github:nix-community/nixvim/nixos-24.11";
      inputs.nixpkgs.follows = "nixpkgs-darwin-stable";
      inputs.home-manager.follows = "home-manager-darwin-stable";
      inputs.nix-darwin.follows = "nix-darwin-stable";
    };

    # plist-manager
    plist-manager-unstable = {
      url = "github:z0al/plist-manager";
      inputs.nixpkgs.follows = "nixpkgs-darwin-unstable";
      inputs.nix-darwin.follows = "nix-darwin-unstable";
      inputs.flake-parts.follows = "flake-parts";
    };
    plist-manager-stable = {
      url = "github:z0al/plist-manager";
      inputs.nixpkgs.follows = "nixpkgs-darwin-stable";
      inputs.nix-darwin.follows = "nix-darwin-stable";
      inputs.flake-parts.follows = "flake-parts";
    };

    # cosmic
    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
      inputs.nixpkgs.follows = "nixpkgs-linux-unstable";
      inputs.nixpkgs-stable.follows = "nixpkgs-linux-stable";
    };
    cosmic-manager = {
      url = "github:heitoraugustoln/cosmic-manager";
      inputs = {
        nixpkgs.follows = "nixpkgs-linux-unstable";
        home-manager.follows = "home-manager-linux-unstable";
        flake-parts.follows = "flake-parts";
      };
    };

    # My own
    flocken = {
      url = "github:mirkolenz/flocken/v2";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };
    quadlet-nix = {
      url = "github:mirkolenz/quadlet-nix/v1";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };
    arguebuf = {
      url = "github:recap-utr/arguebuf-python/v2";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
      inputs.flocken.follows = "flocken";
    };

    # Utils
    pyproject-nix = {
      url = "github:pyproject-nix/pyproject.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    uv2nix = {
      url = "github:pyproject-nix/uv2nix";
      inputs.pyproject-nix.follows = "pyproject-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pyproject-build-systems = {
      url = "github:pyproject-nix/build-system-pkgs";
      inputs.pyproject-nix.follows = "pyproject-nix";
      inputs.uv2nix.follows = "uv2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs-linux-unstable";
    };
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
