{ inputs, ... }:
{
  imports = [
    inputs.nixos-hardware.nixosModules.common-pc-laptop-ssd
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    ./hardware.nix
  ];
  custom.profile = "workstation";

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  boot.loader = {
    systemd-boot.enable = true;
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
  };

  custom.cuda = {
    enable = false;
    driver = "legacy_470";
    xserverDriver = "nvidiaLegacy470";
  };

  hardware.facetimehd = {
    enable = true;
    withCalibration = true;
  };
}
