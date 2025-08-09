{
  inputs,
  lib',
  os,
  channel,
  lib,
  ...
}:
{
  environment.etc."nix/registry.json" = lib.mkForce {
    text = lib'.self.mkRegistryText { inherit inputs os channel; };
  };
  # https://nixos.org/manual/nix/unstable/command-ref/conf-file.html#available-settings
  custom.nix.settings = rec {
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
    trusted-substituters = substituters ++ [
      "https://mirkolenz.cachix.org"
      "https://wi2trier.cachix.org"
      "https://recap.cachix.org"
      "https://pyproject-nix.cachix.org"
      "ssh://eu.nixbuild.net"
      "https://cache.garnix.io"
    ];
    # https://nix.dev/manual/nix/latest/development/experimental-features
    experimental-features = [
      "flakes"
      "impure-derivations"
      "nix-command"
      "no-url-literals"
      "pipe-operators"
    ];
    accept-flake-config = true;
    commit-lock-file-summary = "chore(deps): update flake.lock";
    download-buffer-size = 1000000000; # 1 GB
    flake-registry = "";
    keep-derivations = false;
    keep-failed = false;
    keep-going = true;
    keep-outputs = true;
    log-lines = 1000;
    nix-path = "nixpkgs=flake:pkgs";
    warn-dirty = false;
  };
}
