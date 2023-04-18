{ pkgs,... }:
{
  imports = [ ./hardware.nix ../server.nix ];
  networking.hostName = "homeserver";
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
}
