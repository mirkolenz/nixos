{ config, inputs, ... }:
{
  custom.profile.isDesktop = true;

  imports = [
    "${inputs.nixos-hardware}/apple/macbook-pro"
    "${inputs.nixos-hardware}/common/cpu/intel/sandy-bridge"
    # "${inputs.nixos-hardware}/common/gpu/nvidia/kepler"
    "${inputs.nixos-hardware}/common/pc/ssd"
    ./hardware.nix
    ./disko.nix
  ];
  # Force dual-channel LVDS to prevent the internal display from being detected twice
  boot.kernelParams = [ "i915.lvds_channel_mode=2" ];
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

  # Force display through Intel iGPU via gmux
  boot.extraModprobeConfig = ''
    options apple-gmux force_igd=y
  '';

  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.legacy_470;
    prime = {
      sync.enable = false;
      nvidiaBusId = "PCI:1:0:0";
      intelBusId = "PCI:0:2:0";
    };
  };

  services.logind.settings.Login = {
    HandleLidSwitch = "suspend";
    HandleLidSwitchExternalPower = "suspend";
    HandleLidSwitchDocked = "ignore";
  };

  systemd.sleep.extraConfig = ''
    AllowSuspend=yes
    AllowHibernation=no
    AllowSuspendThenHibernate=no
    AllowHybridSleep=no
  '';
}
