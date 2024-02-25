{ inputs, ... }:
{
  imports = [
    inputs.nixos-hardware.nixosModules.common-pc-laptop-ssd
    inputs.nixos-hardware.nixosModules.common-cpu-intel-cpu-only
    inputs.nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
    ./hardware.nix
    ../../profiles/workstation.nix
  ];

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  boot.loader = {
    systemd-boot.enable = true;
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
  };

  custom.cuda = {
    enable = true;
    driver = "legacy_470";
    xserverDriver = "nvidiaLegacy470";
  };

  powerManagement.cpuFreqGovernor = "performance";

  services = {
    auto-cpufreq.enable = true;
    thermald.enable = true;
  };
}
