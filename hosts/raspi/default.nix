# https://nixos.wiki/wiki/NixOS_on_ARM#Installation
{ lib, extras, ... }:
let
  inherit (extras) pkgsUnstable;
in
{
  imports = [
    ./hardware.nix
    ../../templates/server.nix
  ];
  networking.hostName = "raspi";
  boot.binfmt.emulatedSystems = [ "x86_64-linux" ];

  hardware.raspberry-pi."4" = {
    # https://github.com/NixOS/nixos-hardware/blob/master/raspberry-pi/4/poe-plus-hat.nix
    poe-plus-hat.enable = true;
    # https://github.com/NixOS/nixos-hardware/blob/master/raspberry-pi/4/audio.nix
    audio.enable = true;
  };
  # TODO: Remove for 23.05
  boot.kernelPackages = lib.mkForce pkgsUnstable.linuxKernel.packages.linux_rpi4;
}
