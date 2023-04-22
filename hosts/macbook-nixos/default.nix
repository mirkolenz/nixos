{ config, pkgs, ... }:
{
  imports = [
    ./hardware.nix
    ../../templates/workstation.nix
  ];
  services.openssh.enable = true;

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  boot.loader = {
    systemd-boot.enable = true;
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
    };
  };

  # Not working due to failing `lenovo_fix.service`
  # services.throttled.enable = true;

  powerManagement = {
    enable = true;
    cpuFreqGovernor = "performance";
  };

  networking.hostName = "macbook-nixos";
}
