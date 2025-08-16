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
  custom.nix.settings = {
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
    trusted-substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
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
