# https://nixos.wiki/wiki/NixOS_on_ARM#Installation
{ extras, ... }:
{
  imports = [
    ./hardware.nix
    ./hotfix.nix
    ../server.nix
  ];
  networking.hostName = "raspi";
  boot.binfmt.emulatedSystems = [ "x86_64-linux" ];
}
