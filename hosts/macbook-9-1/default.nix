{ inputs, ... }:
{
  imports = [
    "${inputs.nixos-hardware}/apple"
    "${inputs.nixos-hardware}/common/cpu/intel"
    "${inputs.nixos-hardware}/common/pc/laptop/ssd"
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

  custom.nvidia = {
    enable = false;
    driver = "legacy_470";
    xserverDriver = "nvidiaLegacy470";
  };

  hardware.facetimehd = {
    enable = true;
    withCalibration = true;
  };
}
