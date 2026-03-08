{
  inputs,
  lib',
  ...
}:
{
  custom.profile.isDesktop = true;

  imports = lib'.flocken.getModules ./. ++ [
    "${inputs.nixos-hardware}/apple/macbook-pro"
    "${inputs.nixos-hardware}/common/cpu/intel/sandy-bridge"
    "${inputs.nixos-hardware}/common/pc/ssd"
  ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = "/boot";
  };

  # force dual-channel LVDS to prevent the internal display from being detected twice
  boot.kernelParams = [ "i915.lvds_channel_mode=2" ];

  swapDevices = [
    {
      device = "/swapfile";
      size = 4 * 1024;
    }
  ];

  # force intel iGPU
  boot.extraModprobeConfig = ''
    options apple-gmux force_igd=y
  '';
}
