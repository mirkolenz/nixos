{ inputs, ... }:
{
  imports = [
    "${inputs.nixos-hardware}/apple/t2"
    "${inputs.nixos-hardware}/common/pc/ssd"
    ./hardware.nix
  ];
  custom.profile.isDesktop = true;

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  boot.loader = {
    systemd-boot.enable = true;
    efi.efiSysMountPoint = "/boot";
  };

  hardware.facetimehd = {
    enable = true;
    withCalibration = true;
  };

  hardware.apple-t2 = {
    enableIGPU = true;
    kernelChannel = "stable";
    firmware = {
      enable = true;
      version = "ventura";
    };
  };
}
