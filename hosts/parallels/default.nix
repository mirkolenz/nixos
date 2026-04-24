{ lib', ... }:
{
  imports = lib'.flocken.getModules ./.;

  custom.features = {
    withDisplay = true;
    withOptionals = true;
  };

  security.sudo.wheelNeedsPassword = false;

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = "/boot";
  };

  hardware.parallels.enable = true;
}
