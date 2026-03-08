{
  inputs,
  lib',
  ...
}:
{
  imports = lib'.flocken.getModules ./. ++ [
    "${inputs.nixos-hardware}/apple"
    "${inputs.nixos-hardware}/apple/t2"
    "${inputs.nixos-hardware}/common/cpu/intel/coffee-lake/cpu-only.nix"
    "${inputs.nixos-hardware}/common/pc/laptop"
    "${inputs.nixos-hardware}/common/pc/ssd"
  ];
  custom.profile.isDesktop = true;

  # disable intel iGPU so amdgpu is the sole GPU driver
  boot.blacklistedKernelModules = [ "i915" ];
  boot.kernelParams = [ "i915.modeset=0" ];

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

  # https://wiki.t2linux.org/guides/postinstall/
  # https://github.com/NixOS/nixos-hardware/blob/master/apple/t2/default.nix
  hardware.apple-t2 = {
    enableIGPU = false;
    kernelChannel = "stable";
    firmware.enable = true;
  };

  # The AMD dGPU runs as the sole display device since the Intel iGPU is disabled.
  # Constrain it to low power mode to prevent overheating and unexpected shutdowns.
  # https://wiki.t2linux.org/guides/hybrid-graphics/
  services.udev.extraRules = ''
    SUBSYSTEM=="drm", DRIVERS=="amdgpu", ATTR{device/power_dpm_force_performance_level}="low"
  '';

  # https://github.com/AsahiLinux/tiny-dfr/blob/master/share/tiny-dfr/config.toml
  hardware.apple.touchBar = {
    enable = true;
    settings = {
      MediaLayerDefault = true;
    };
  };
}
