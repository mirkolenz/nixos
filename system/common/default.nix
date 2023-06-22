{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./users.nix
    ./shell.nix
    ./secrets.nix
    ../../home
    ../cachix
  ];

  # networking.firewall = {
  #   enable = true;
  #   allowPing = true;
  # };

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
