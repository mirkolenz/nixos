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
      substituters = [ "https://mirkolenz.cachix.org" ];
      trusted-public-keys = [ "mirkolenz.cachix.org-1:R0dgCJ93t33K/gncNbKgUdJzwgsYVXeExRsZNz5jpho=" ];
    };
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
    registry = import ../../registry.nix args;
  };
}
