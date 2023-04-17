{ config, pkgs, ... }:
{
  imports = [
    ./hardware.nix
    ../workstation.nix
  ];

  boot.loader = {
    systemd-boot.enable = true;
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
    };
  };

  networking.hostName = "macbook-nixos";
}
