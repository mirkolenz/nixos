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

  # https://zaiste.net/posts/shell-commands-rust/
  environment.systemPackages = with pkgs; [
    bat
    exa
    fd
    procs
    sd
    ripgrep
    bottom
    tealdeer
    bandwhich
    delta
    gnumake
    massren
    rsync
    curl
    wget
  ];

  nix = {
    package = pkgs.nix;
    settings = {
      # https://github.com/NixOS/nix/issues/7273#issuecomment-1310213986
      auto-optimise-store = false;
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
