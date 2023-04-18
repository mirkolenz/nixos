{ config, pkgs, ... }:
{
  imports = [
    ./hardware.nix
    ../workstation.nix
    ../ssh.nix
  ];

  boot.loader = {
    systemd-boot.enable = true;
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
    };
  };

  services.throttled.enable = true;

  powerManagement = {
    enable = true;
    cpuFreqGovernor = "performance";
  };

  networking.hostName = "macbook-nixos";
}
