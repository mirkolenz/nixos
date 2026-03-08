{
  inputs,
  lib',
  ...
}:
{
  imports = lib'.flocken.getModules ./. ++ [
    "${inputs.nixos-hardware}/apple/macbook-pro"
    "${inputs.nixos-hardware}/common/cpu/intel/haswell/cpu-only.nix"
    "${inputs.nixos-hardware}/common/gpu/intel/disable.nix"
    "${inputs.nixos-hardware}/common/pc/ssd"
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

  # prefer S3 deep sleep if available, fall back to s2idle
  systemd.sleep.settings.Sleep = {
    SuspendState = "mem";
    MemorySleepMode = "deep";
  };
}
