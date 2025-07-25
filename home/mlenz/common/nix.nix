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
    package = pkgs.nix;
    registry = lib'.self.mkRegistry { inherit inputs os channel; };
    nixPath = [ "nixpkgs=flake:pkgs" ];
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
      commit-lock-file-summary = "chore(deps): update flake.lock";
      log-lines = 1000;
      warn-dirty = false;
    };
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
  };
}
