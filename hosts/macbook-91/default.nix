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

  # video devices: card0-Unknown-1 (simpledrm/dGPU), card1-LVDS-1 (i915), card1-VGA-1 (i915)
  # disable phantom display created by simpledrm from the EFI framebuffer on the dGPU
  boot.kernelParams = [ "video=Unknown-1:d" ];

  boot.blacklistedKernelModules = [ "nouveau" ];

  swapDevices = [
    {
      device = "/swapfile";
      size = 4 * 1024;
    }
  ];

  # force intel iGPU via the apple gmux GPU multiplexer
  boot.extraModprobeConfig = ''
    options apple-gmux force_igd=y
  '';
}
