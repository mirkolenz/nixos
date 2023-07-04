{
  pkgs,
  lib,
  ...
}: {
  nix = {
    package = pkgs.nix;
    settings = {
      experimental-features = ["nix-command" "flakes" "impure-derivations" "ca-derivations"];
      keep-going = true;
      keep-outputs = true;
      keep-derivations = true;
      keep-failed = false;
      # https://github.com/NixOS/nix/issues/7273#issuecomment-1310213986
      auto-optimise-store = pkgs.stdenv.isLinux;
      # https://github.com/DeterminateSystems/nix-installer/pull/270
      extra-nix-path = "nixpkgs=flake:nixpkgs";
      # https://github.com/DeterminateSystems/nix-installer/pull/196
      # auto-allocate-uids = true;
      # does not build on Linux with 23.05
      # plugin-files = ["${pkgs.nix-plugins}/lib/nix/plugins"];
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
  };
}