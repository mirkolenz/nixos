{ inputs, ... }:
{
  imports = [
    "${inputs.nixos-hardware}/apple/t2"
    "${inputs.nixos-hardware}/common/pc/ssd"
    ./disko.nix
    ./hardware.nix
  ];
  custom.profile.isDesktop = true;

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = "/boot";
  };

  swapDevices = [
    {
      device = "/swapfile";
      size = 4 * 1024;
    }
  ];

  virtualisation.libvirtd.enable = true;
  services.openssh.enable = true;

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
