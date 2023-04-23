{ pkgs, ... }:
{
  imports = [
    ./hardware.nix
    ../../templates/server.nix
  ];
  networking.hostName = "homeserver";
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
}
