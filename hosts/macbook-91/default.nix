{ config, inputs, ... }:
{
  custom.profile.isDesktop = true;

  imports = [
    "${inputs.nixos-hardware}/apple"
    "${inputs.nixos-hardware}/common/cpu/intel/sandy-bridge"
    "${inputs.nixos-hardware}/common/gpu/nvidia/kepler"
    "${inputs.nixos-hardware}/common/pc/ssd"
    ./hardware.nix
    ./disko.nix
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

  services.xserver.videoDrivers = [ "nvidiaLegacy470" ];
  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.legacy_470;
    prime = {
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
