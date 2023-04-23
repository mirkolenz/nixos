{ pkgs, extras, lib, ... }:
let
  inherit (extras) unstable;
in
{
  imports = [
    ./users.nix
    ./shell.nix
    ../../home
  ];

  environment.systemPackages = with pkgs; [
    curl
    exa
    fd
    gnumake
    massren
    ripgrep
    rsync
    wget
    macchina
  ];

  nix = {
    package = pkgs.nix;
    settings = {
      auto-optimise-store = true;
    };
    gc = lib.mkMerge [
      {
        automatic = true;
        options = "--delete-older-than 30d";
      }
      (lib.optionalAttrs (pkgs.stdenv.isLinux) {
        dates = "weekly";
      })
      (lib.optionalAttrs (pkgs.stdenv.isDarwin) {
        interval = { Weekday = 0; Hour = 0; Minute = 0; };
      })
    ];
  };
}
