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
      max-jobs = "auto";
      keep-going = true;
      keep-outputs = true;
      keep-derivations = false;
      keep-failed = false;
      # does not build on Linux
      # plugin-files = ["${pkgs.nix-plugins}/lib/nix/plugins"];
      allowed-users = [ user.login ];
      log-lines = 1000;
      builders-use-substitutes = true;
      warn-dirty = false;
      accept-flake-config = true;
      sandbox = true;
    };
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
    optimise.automatic = true;
    registry = lib'.self.mkRegistry { inherit inputs os channel; };
    channel.enable = false;
  };
}
