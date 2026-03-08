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
  sleep = lib.getExe' pkgs.coreutils "sleep";
  systemctl = lib.getExe' pkgs.systemd "systemctl";
in
{
  imports = lib'.flocken.getModules ./. ++ [
    "${inputs.nixos-hardware}/apple/macbook-pro"
    "${inputs.nixos-hardware}/apple/t2"
    "${inputs.nixos-hardware}/common/cpu/intel/coffee-lake"
    "${inputs.nixos-hardware}/common/pc/ssd"
  ];
  custom.profile.isDesktop = true;

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = "/boot";
  };

  # The imported nixos-hardware Coffee Lake module defaults to i915.enable_guc=2.
  # Value 2 enables HuC loading only, while value 3 enables GuC submission plus HuC loading.
  # The T2 Linux hybrid graphics guide recommends 3 on MacBookPro16,1 to avoid black-screen wakeups.
  # Use mkAfter so this host-specific value is appended after the upstream default.
  # https://wiki.t2linux.org/guides/hybrid-graphics/
  boot.kernelParams = lib.mkAfter [ "i915.enable_guc=3" ];

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
    enableIGPU = true;
    kernelChannel = "stable";
    firmware.enable = true;
  };

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
        # ${modprobe} -r brcmfmac_wcc || true
        # ${modprobe} -r brcmfmac || true
        ${rmmod} -f apple-bce || true
      '';
      ExecStop = pkgs.writeShellScript "suspend-t2-post" ''
        ${sleep} 4
        ${modprobe} apple-bce || true
        # ${sleep} 4
        # ${modprobe} brcmfmac || true
        # ${sleep} 2
        # ${modprobe} brcmfmac_wcc || true
        ${sleep} 4
        ${modprobe} hid_appletb_bl || true
        ${sleep} 2
        ${modprobe} hid_appletb_kbd || true
        ${sleep} 2
        ${modprobe} appletbdrm || true
        ${sleep} 2
        ${systemctl} start tiny-dfr.service || true
      '';
    };
  };
}
