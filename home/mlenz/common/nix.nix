{
  pkgs,
  lib,
  osConfig,
  os,
  channel,
  inputs,
  lib',
  ...
}:
{
  nix = lib.mkIf (osConfig == { }) {
    package = inputs.nix.packages.${pkgs.stdenv.system}.default;
    registry = lib'.self.mkRegistry { inherit inputs os channel; };
    nixPath = [ "nixpkgs=flake:nixpkgs" ];
    keepOldNixPath = false;
    settings = {
      experimental-features = [
        "flakes"
        "impure-derivations"
        "nix-command"
        "no-url-literals"
        "pipe-operators"
      ];
      accept-flake-config = true;
      bash-prompt-prefix = "(nix:$name)\\040";
      log-lines = 1000;
      warn-dirty = false;
    };
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
  };
}
