{
  inputs,
  lib',
  ...
}:
{
  custom.features.withDisplay = true;

  imports = lib'.flocken.getModules ./. ++ [
    "${inputs.nixos-hardware}/apple"
    "${inputs.nixos-hardware}/common/cpu/intel/sandy-bridge/cpu-only.nix"
    "${inputs.nixos-hardware}/common/pc/laptop"
    "${inputs.nixos-hardware}/common/pc/ssd"
  ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = "/boot";
  };

  # disable intel iGPU so nouveau is the sole GPU driver;
  # nixos-hardware/common/gpu/intel/disable.nix uses lib.mkDefault which is
  # overridden by the hardened profile in system/linux-children/hardening.nix
  boot.blacklistedKernelModules = [ "i915" ];
  boot.kernelParams = [ "i915.modeset=0" ];

  swapDevices = [
    {
      device = "/swapfile";
      size = 4 * 1024;
    }
  ];

}
