{
  pkgs,
  inputs,
  lib,
  user,
  ...
}: {
  nix = {
    package = pkgs.nix;
    # https://nixos.org/manual/nix/unstable/command-ref/conf-file.html#available-settings
    settings = {
      # https://nixos.org/manual/nix/unstable/contributing/experimental-features.html
      experimental-features = ["nix-command" "flakes" "impure-derivations" "ca-derivations" "repl-flake"];
      max-jobs = "auto";
      keep-going = true;
      keep-outputs = true;
      keep-derivations = false;
      keep-failed = false;
      # https://github.com/NixOS/nix/issues/7273#issuecomment-1310213986
      auto-optimise-store = pkgs.stdenv.isLinux;
      # https://github.com/DeterminateSystems/nix-installer/pull/270
      extra-nix-path = "nixpkgs=flake:nixpkgs";
      # https://github.com/DeterminateSystems/nix-installer/pull/196
      # auto-allocate-uids = true;
      # does not build on Linux
      # plugin-files = ["${pkgs.nix-plugins}/lib/nix/plugins"];
      allowed-users = ["@wheel"];
      trusted-users = ["root" user.login];
    };
    gc = lib.mkMerge [
      {
        automatic = true;
        options = "--delete-older-than 7d";
      }
      (lib.optionalAttrs (pkgs.stdenv.isLinux) {
        dates = "daily";
      })
      (lib.optionalAttrs (pkgs.stdenv.isDarwin) {
        interval = {
          Hour = 1;
          Minute = 0;
        };
      })
    ];
    registry = import ../../registry.nix {
      inherit inputs pkgs;
    };
  };
}
