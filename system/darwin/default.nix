{ lib, pkgs, extras, config, ... }:
let
  inherit (extras) unstable;
in
{
  imports = [
    ./homebrew.nix
    ./settings.nix
  ];

  environment.loginShell = pkgs.fish;
  services.nix-daemon.enable = true;
  # TODO: Document that this content shall be copied from `/etc/nix/nix.conf` after running the nix-installer
  nix.settings = {
    extra-nix-path = "nixpkgs=flake:nixpkgs";
    build-users-group = "nixbld";
  };

  environment.systemPackages = with unstable; [
    texlive.combined.scheme-full
  ];
}
