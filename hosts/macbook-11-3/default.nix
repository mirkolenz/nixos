{ inputs, ... }:
{
  imports = [
    inputs.nixos-hardware.nixosModules.common-pc-laptop-ssd
    inputs.nixos-hardware.nixosModules.common-cpu-intel-cpu-only
    inputs.nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
    inputs.nixos-hardware.nixosModules.common-hidpi
    ./hardware.nix
    ../../profiles/workstation.nix
  ];
  services.openssh.enable = true;

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  boot.loader = {
    systemd-boot.enable = true;
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
    };
  };

  custom.cuda = {
    enable = true;
    driver = "legacy_470";
    xserverDriver = "nvidiaLegacy470";
  };

  hardware.nvidia.prime = {
    sync.enable = false;
    nvidiaBusId = "PCI:1:0:0";
    intelBusId = "PCI:0:2:0";
  };

  powerManagement.cpuFreqGovernor = "performance";

  services = {
    auto-cpufreq.enable = true;
    thermald.enable = true;
  };
}
