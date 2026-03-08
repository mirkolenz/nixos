{
  inputs,
  pkgs,
  lib,
  lib',
  ...
}:
let
  modprobe = lib.getExe' pkgs.kmod "modprobe";
  rmmod = lib.getExe' pkgs.kmod "rmmod";
  systemctl = lib.getExe' pkgs.systemd "systemctl";
  settle = "${lib.getExe' pkgs.systemd "udevadm"} settle --timeout=10";
in
{
  imports = lib'.flocken.getModules ./. ++ [
    "${inputs.nixos-hardware}/apple"
    "${inputs.nixos-hardware}/apple/t2"
    "${inputs.nixos-hardware}/common/cpu/intel/coffee-lake/cpu-only.nix"
    "${inputs.nixos-hardware}/common/gpu/intel/disable.nix"
    "${inputs.nixos-hardware}/common/pc/laptop"
    "${inputs.nixos-hardware}/common/pc/ssd"
  ];
  custom.profile.isDesktop = true;

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = "/boot";
  };

  # The official T2 suspend workaround force-unloads apple-bce with rmmod -f during suspend.
  # Enable MODULE_FORCE_UNLOAD explicitly so that workaround is supported by this kernel build.
  # https://wiki.t2linux.org/guides/postinstall/#suspend-workaround
  boot.kernelPatches = [
    {
      name = "t2-suspend-force-unload";
      patch = null;
      structuredExtraConfig = {
        MODULE_FORCE_UNLOAD = lib.kernel.yes;
      };
    }
  ];

  swapDevices = [
    {
      device = "/swapfile";
      size = 4 * 1024;
    }
  ];

  # https://wiki.t2linux.org/guides/postinstall/
  # https://github.com/NixOS/nixos-hardware/blob/master/apple/t2/default.nix
  hardware.apple-t2 = {
    enableIGPU = false;
    kernelChannel = "stable";
    firmware.enable = true;
  };

  # The AMD dGPU runs as the sole display device since the Intel iGPU is disabled.
  # Constrain it to low power mode to prevent overheating and unexpected shutdowns.
  # https://wiki.t2linux.org/guides/hybrid-graphics/
  services.udev.extraRules = ''
    SUBSYSTEM=="drm", DRIVERS=="amdgpu", ATTR{device/power_dpm_force_performance_level}="low"
  '';

  # https://github.com/AsahiLinux/tiny-dfr/blob/master/share/tiny-dfr/config.toml
  hardware.apple.touchBar = {
    enable = true;
    settings = {
      MediaLayerDefault = true;
    };
  };

  systemd.sleep.settings.Sleep = {
    SuspendState = "mem";
    MemorySleepMode = "deep";
  };

  # This service is a NixOS-specific merge of the official T2 Linux suspend workaround examples.
  # It combines the Fedora and Arch systemd flow for apple-bce and optional Wi-Fi reloads.
  # It also incorporates the Gentoo Touch Bar and tiny-dfr resume sequence where applicable.
  # https://wiki.t2linux.org/guides/postinstall/#suspend-workaround
  systemd.services.suspend-t2 = {
    description = "Reload Apple drivers on suspend/resume to prevent crashes";
    before = [ "sleep.target" ];
    wantedBy = [ "sleep.target" ];
    unitConfig.StopWhenUnneeded = true;
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = pkgs.writeShellScript "suspend-t2-pre" ''
        ${systemctl} stop tiny-dfr.service || true
        ${modprobe} -r appletbdrm || true
        ${modprobe} -r hid_appletb_kbd || true
        ${modprobe} -r hid_appletb_bl || true
        ${modprobe} -r brcmfmac_wcc || true
        ${modprobe} -r brcmfmac || true
        ${rmmod} -f apple-bce || true
      '';
      ExecStop = pkgs.writeShellScript "suspend-t2-post" ''
        ${modprobe} apple-bce || true
        ${settle}
        ${modprobe} brcmfmac || true
        ${settle}
        ${modprobe} brcmfmac_wcc || true
        ${settle}
        ${modprobe} hid_appletb_bl || true
        ${settle}
        ${modprobe} hid_appletb_kbd || true
        ${settle}
        ${modprobe} appletbdrm || true
        ${settle}
        ${systemctl} start tiny-dfr.service || true
      '';
    };
  };
}
