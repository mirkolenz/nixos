{ inputs, ... }:
{
  imports = [
    inputs.nixos-hardware.nixosModules.common-pc-laptop-ssd
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    # inputs.nixos-hardware.nixosModules.common-cpu-intel-cpu-only
    # inputs.nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
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
    xserverDriver = "nvidiaLegacy470";
  };

  hardware.nvidia.prime = {
    sync.enable = false;
    nvidiaBusId = "PCI:1:0:0";
    intelBusId = "PCI:0:2:0";
  };

  services = {
    thermald.enable = true;
  };

  # https://gist.github.com/wmealing/2dd2b543c4d3cff6cab7
  # https://askubuntu.com/a/1242574
  # https://www.reddit.com/r/mac/comments/9pyort/apple_macbook_pro_sudden_crash_fix_for_models/
  # https://www.thomas-krenn.com/en/wiki/Processor_P-states_and_C-states
  boot.kernelParams = [ "intel_idle.max_cstate=3" ];
}
