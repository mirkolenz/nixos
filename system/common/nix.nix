{
  user,
  config,
  inputs,
  lib',
  os,
  channel,
  pkgs,
  ...
}:
{
  nix = {
    package = pkgs.nix;
    extraOptions = ''
      !include nix.local.conf
    '';
    # https://nixos.org/manual/nix/unstable/command-ref/conf-file.html#available-settings
    settings = {
      substituters = [
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "mirkolenz.cachix.org-1:R0dgCJ93t33K/gncNbKgUdJzwgsYVXeExRsZNz5jpho="
        "wi2trier.cachix.org-1:8wJvKtRD8XUqYZMdjECTsN1zWxHy9kvp5aoPQiAm1fY="
        "recap.cachix.org-1:KElwRDtaJbbQxmmS2SyxWHqs9bdJbaZHzb2iINTfQws="
        "pyproject-nix.cachix.org-1:UNzugsOlQIu2iOz0VyZNBQm2JSrL/kwxeCcFGw+jMe0="
        "nixbuild.net/BMAQHF-1:Q4LUtdLL0mXTO1Cs5jhcOKDZQUVlNA0u3QItwZ6uyq0="
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      ];
      trusted-substituters = config.nix.settings.substituters ++ [
        "https://mirkolenz.cachix.org"
        "https://wi2trier.cachix.org"
        "https://recap.cachix.org"
        "https://pyproject-nix.cachix.org"
        "ssh://eu.nixbuild.net"
        "https://cache.garnix.io"
      ];
      # https://nixos.org/manual/nix/unstable/contributing/experimental-features.html
      experimental-features = [
        "flakes"
        "impure-derivations"
        "nix-command"
        "no-url-literals"
        "pipe-operators"
      ];
      accept-flake-config = true;
      allow-import-from-derivation = true;
      allowed-users = [ user.login ];
      always-allow-substitutes = true;
      bash-prompt-prefix = "(nix:$name)\\040";
      builders-use-substitutes = true;
      download-buffer-size = 1000000000; # 1 GB
      keep-derivations = false;
      keep-failed = false;
      keep-going = true;
      keep-outputs = true;
      log-lines = 1000;
      max-jobs = "auto";
      upgrade-nix-store-path-url = "https://install.determinate.systems/nix-upgrade/stable/universal";
      warn-dirty = false;
    };
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
    optimise.automatic = true;
    registry = lib'.self.mkRegistry { inherit inputs os channel; };
    channel.enable = false;
    # we set pkgs in the registry to the packages used to build the system
    # nixpkgs is set to nixpkgs-unstable in the registry
    nixPath = [ "nixpkgs=flake:pkgs" ];
  };
  # we do this ourselves
  nixpkgs.flake = {
    setFlakeRegistry = false;
    setNixPath = false;
  };
}
