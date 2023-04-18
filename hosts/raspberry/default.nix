# https://nixos.wiki/wiki/NixOS_on_ARM#Installation
{ extras, ... }:
let
  inherit (extras.inputs) nixos-hardware;
in
{
  imports = [
    nixos-hardware.nixosModules.raspberry-pi-4
    ../server.nix
  ];
  networking.hostName = "raspi";
  boot.binfmt.emulatedSystems = [ "x86_64-linux" ];
}
