{
  config,
  inputs,
  lib',
  ...
}:
{
  imports = lib'.flocken.getModules ./. ++ [
    "${inputs.nixos-hardware}/apple/macbook-pro"
    "${inputs.nixos-hardware}/common/cpu/intel/haswell"
    # "${inputs.nixos-hardware}/common/gpu/nvidia/kepler"
    "${inputs.nixos-hardware}/common/pc/ssd"
  ];
  custom.profile.isDesktop = true;

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = "/boot";
  };

  # COSMIC runs this host on the Intel modesetting stack, so explicitly blacklist
  # the legacy NVIDIA path instead of relying on the inactive hardware.nvidia module.
  boot.blacklistedKernelModules = [
    "nouveau"
    "nova_core"
    "nvidiafb"
  ];

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

  # https://gist.github.com/wmealing/2dd2b543c4d3cff6cab7
  # https://askubuntu.com/a/1242574
  # https://www.reddit.com/r/mac/comments/9pyort/apple_macbook_pro_sudden_crash_fix_for_models/
  # https://www.thomas-krenn.com/en/wiki/Processor_P-states_and_C-states
  boot.kernelParams = [
    "intel_idle.max_cstate=3" # allow intel_idle states C0-C3 (sleep)
    # "processor.max_cstate=3" # allow acpi_idle states C0-C3 (sleep)
  ];

  systemd.sleep.settings.Sleep = {
    SuspendState = "mem";
    MemorySleepMode = "deep";
  };
}
