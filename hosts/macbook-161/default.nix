{
  inputs,
  user,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    "${inputs.nixos-hardware}/apple/macbook-pro"
    "${inputs.nixos-hardware}/apple/t2"
    "${inputs.nixos-hardware}/common/cpu/intel/coffee-lake"
    "${inputs.nixos-hardware}/common/pc/ssd"
    ./disko.nix
    ./hardware.nix
    ./restic.nix
  ];
  custom.profile.isDesktop = true;

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
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

  services.displayManager.autoLogin.user = user.login;

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

  services.logind.settings.Login = {
    HandleLidSwitch = "suspend";
    HandleLidSwitchExternalPower = "suspend";
    HandleLidSwitchDocked = "ignore";
  };

  systemd.sleep.settings.Sleep = {
    AllowSuspend = "yes";
    AllowHibernation = "no";
    AllowSuspendThenHibernate = "no";
    AllowHybridSleep = "no";
    SuspendState = "mem";
    MemorySleepMode = "deep";
  };

  # https://wiki.t2linux.org/guides/postinstall/#suspend-workaround
  systemd.services.suspend-t2 = {
    description = "Reload Apple drivers on suspend/resume to prevent crashes";
    before = [ "suspend.target" ];
    wantedBy = [ "suspend.target" ];
    unitConfig.StopWhenUnneeded = true;
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "-${lib.getExe' pkgs.kmod "modprobe"} -r apple-bce";
      ExecStop = "-${lib.getExe' pkgs.kmod "modprobe"} apple-bce";
    };
  };
}
