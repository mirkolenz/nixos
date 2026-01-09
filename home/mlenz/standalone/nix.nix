{
  os,
  lib',
  pkgs,
  ...
}:
{
  nix = {
    package = pkgs.determinate-nix;
    registry = lib'.mkRegistry os;
    settings = {
      experimental-features = [
        "flakes"
        "impure-derivations"
        "nix-command"
        "no-url-literals"
        "pipe-operators"
      ];
      nix-path = [
        "pkgs=flake:pkgs"
      ];
      accept-flake-config = true;
      bash-prompt-prefix = "(nix:$name)\\040";
      commit-lock-file-summary = "chore(deps): update flake.lock";
      # log-lines = 200; # https://github.com/nixos/nix/issues/13399
      warn-dirty = false;
    };
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
  };
}
