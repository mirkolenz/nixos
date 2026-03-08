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

  systemd.sleep.settings.Sleep = {
    SuspendState = "freeze";
  };
}
