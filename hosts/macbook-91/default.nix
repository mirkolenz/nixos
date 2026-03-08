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

  swapDevices = [
    {
      device = "/swapfile";
      size = 4 * 1024;
    }
  ];

  # force intel iGPU via the apple gmux GPU multiplexer
  # disable nouveau modesetting to prevent phantom DRM outputs
  # that cause cosmic-comp to block lid switch sleep
  boot.extraModprobeConfig = ''
    options apple-gmux force_igd=y
    options nouveau modeset=0
  '';

}
