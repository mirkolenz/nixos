{ config, inputs, ... }:
{
  imports = [
    "${inputs.nixos-hardware}/apple"
    "${inputs.nixos-hardware}/common/cpu/intel/sandy-bridge"
    "${inputs.nixos-hardware}/common/gpu/nvidia/kepler"
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

  services.xserver.videoDrivers = [ "nvidiaLegacy470" ];
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.legacy_470;

  hardware.facetimehd = {
    enable = true;
    withCalibration = true;
  };
}
