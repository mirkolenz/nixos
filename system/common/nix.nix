args@{
  lib,
  pkgs,
  user,
  ...
}:
{
  nix = {
    package = pkgs.nix;
    extraOptions = ''
      !include nix.local.conf
    '';
    nixPath = lib.mkForce [ "nixpkgs=flake:nixpkgs" ];
    # https://nixos.org/manual/nix/unstable/command-ref/conf-file.html#available-settings
    settings = {
      # https://nixos.org/manual/nix/unstable/contributing/experimental-features.html
      experimental-features = [
        "nix-command"
        "flakes"
        "impure-derivations"
        "ca-derivations"
        "repl-flake"
      ];
      max-jobs = "auto";
      keep-going = true;
      keep-outputs = true;
      keep-derivations = false;
      keep-failed = false;
      # https://github.com/DeterminateSystems/nix-installer/pull/196
      # auto-allocate-uids = true;
      # does not build on Linux
      # plugin-files = ["${pkgs.nix-plugins}/lib/nix/plugins"];
      allowed-users = [ "@wheel" ];
      trusted-users = [
        "root"
        user.login
      ];
      log-lines = 25;
      builders-use-substitutes = true;
      warn-dirty = false;
    };
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
    optimise.automatic = true;
    registry = import ../../registry.nix args;
  };
  custom.caches = [
    {
      url = "https://mirkolenz.cachix.org";
      key = "mirkolenz.cachix.org-1:R0dgCJ93t33K/gncNbKgUdJzwgsYVXeExRsZNz5jpho=";
    }
    {
      url = "https://nix-community.cachix.org";
      key = "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=";
    }
  ];
}
