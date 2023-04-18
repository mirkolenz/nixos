{ pkgs,... }:
{
  imports = [ ./hardware.nix ../server.nix ];
  networking.hostName = "homeserver";
}
