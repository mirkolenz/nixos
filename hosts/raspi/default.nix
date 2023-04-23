# https://nixos.wiki/wiki/NixOS_on_ARM#Installation
{ ... }:
{
  imports = [
    ./hardware.nix
    ../../fixes/raspi4-kernel.nix
    ../../templates/server.nix
  ];
  networking.hostName = "raspi";
  boot.binfmt.emulatedSystems = [ "x86_64-linux" ];
}
