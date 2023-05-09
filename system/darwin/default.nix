{ lib, pkgs, extras, config, ... }:
let
  inherit (extras) pkgsUnstable;
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
    # https://github.com/NixOS/nix/issues/7273#issuecomment-1310213986
    auto-optimise-store = lib.mkDefault false;
  };

  environment.systemPackages = with pkgsUnstable; [
    texlive.combined.scheme-full
  ];
}
