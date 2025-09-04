{
  lib,
  os,
  channel,
  inputs,
  lib',
  pkgs,
  ...
}:
{
  xdg.configFile."nix/registry.json" = lib.mkForce {
    text = lib'.self.mkRegistryText { inherit inputs os channel; };
  };
  nix = {
    package = pkgs.determinate-nix;
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
      flake-registry = "";
      # log-lines = 1000; # https://github.com/nixos/nix/issues/13399
      warn-dirty = false;
    };
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
  };
}
