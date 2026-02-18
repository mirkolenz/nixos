{ config, inputs, ... }:
{
  imports = [
    "${inputs.nixos-hardware}/apple"
    "${inputs.nixos-hardware}/common/cpu/intel/haswell"
    "${inputs.nixos-hardware}/common/gpu/nvidia/kepler"
    "${inputs.nixos-hardware}/common/pc/ssd"
    ./hardware.nix
  ];
  custom.profile.isDesktop = true;

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = "/boot/efi";
  };

  virtualisation.libvirtd.enable = true;
  services.openssh.enable = true;

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.legacy_470;
    prime = {
      nvidiaBusId = "PCI:1:0:0";
      intelBusId = "PCI:0:2:0";
    };
  };

  # enable iGPU
  boot.extraModprobeConfig = ''
    options apple-gmux force_igd=y
  '';

  # https://gist.github.com/wmealing/2dd2b543c4d3cff6cab7
  # https://askubuntu.com/a/1242574
  # https://www.reddit.com/r/mac/comments/9pyort/apple_macbook_pro_sudden_crash_fix_for_models/
  # https://www.thomas-krenn.com/en/wiki/Processor_P-states_and_C-states
  boot.kernelParams = [
    "mem_sleep_default=s2idle" # systemd-sleep alone doesn't work
    "intel_idle.max_cstate=3" # allow intel_idle states C0-C3 (sleep)
    # "processor.max_cstate=3" # allow acpi_idle states C0-C3 (sleep)
  ];

  # https://github.com/basecamp/omarchy/issues/1840
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
    SuspendState=freeze
    MemorySleepMode=s2idle
  '';
}
