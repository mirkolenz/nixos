{ lib', ... }:
{
  imports = lib'.flocken.getModules ./.;

  custom.features.withAlwaysOn = true;

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = "/boot";
  };
}
