{ inputs, ... }:
{
  imports = [
    "${inputs.nixos-hardware}/apple"
    "${inputs.nixos-hardware}/common/cpu/intel/haswell"
    "${inputs.nixos-hardware}/common/gpu/nvidia/disable.nix"
    # "${inputs.nixos-hardware}/common/gpu/nvidia/kepler"
    "${inputs.nixos-hardware}/common/pc/laptop/ssd"
    ./hardware.nix
  ];
  custom.profile = "workstation";
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
    nvidiaBusId = "PCI:1:0:0";
    intelBusId = "PCI:0:2:0";
  };

  hardware.facetimehd = {
    enable = true;
    withCalibration = true;
  };

  # https://gist.github.com/wmealing/2dd2b543c4d3cff6cab7
  # https://askubuntu.com/a/1242574
  # https://www.reddit.com/r/mac/comments/9pyort/apple_macbook_pro_sudden_crash_fix_for_models/
  # https://www.thomas-krenn.com/en/wiki/Processor_P-states_and_C-states
  boot.kernelParams = [
    # disable intel_idle
    "intel_idle.max_cstate=0"
    # allow acpi_idle states C0-C3 (sleep)
    # "processor.max_cstate=3"
  ];
}
