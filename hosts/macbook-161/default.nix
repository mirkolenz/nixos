{ inputs, ... }:
{
  imports = [
    "${inputs.nixos-hardware}/apple"
    "${inputs.nixos-hardware}/apple/t2"
    "${inputs.nixos-hardware}/common/cpu/intel/coffee-lake"
    "${inputs.nixos-hardware}/common/pc/ssd"
    ./disko.nix
    ./hardware.nix
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

  virtualisation.libvirtd.enable = true;
  services.openssh.enable = true;

  # https://wiki.t2linux.org/guides/postinstall/
  # https://github.com/NixOS/nixos-hardware/blob/master/apple/t2/default.nix
  hardware.apple-t2 = {
    enableIGPU = true;
    kernelChannel = "stable";
    firmware = {
      enable = true;
      version = "ventura";
    };
  };

  # https://github.com/AsahiLinux/tiny-dfr/blob/master/share/tiny-dfr/config.toml
  hardware.apple.touchBar = {
    enable = true;
    settings = {
      MediaLayerDefault = true;
    };
  };

  # https://github.com/basecamp/omarchy/issues/1840
  services.logind.settings.Login = {
    HandleLidSwitch = "lock";
    HandleLidSwitchExternalPower = "lock";
    HandleLidSwitchDocked = "ignore";
  };

  systemd.sleep.extraConfig = ''
    AllowSuspend=no
    AllowHibernation=no
    AllowSuspendThenHibernate=no
    AllowHybridSleep=no
    SuspendState=freeze
    MemorySleepMode=s2idle
  '';

  boot.kernelParams = [
    "mem_sleep_default=s2idle" # systemd-sleep alone doesn't work
  ];
}
