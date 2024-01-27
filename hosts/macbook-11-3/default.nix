{ inputs, ... }:
{
  imports = [
    inputs.nixos-hardware.nixosModules.common-pc-laptop-ssd
    inputs.nixos-hardware.nixosModules.common-cpu-intel
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
    enable = false;
    driver = "legacy_470";
  };

  hardware.nvidia.prime = {
    sync.enable = false;
    nvidiaBusId = "PCI:1:0:0";
    intelBusId = "PCI:0:2:0";
  };

  powerManagement.cpuFreqGovernor = "powersave";
}
