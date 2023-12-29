{
  config,
  lib,
  pkgs,
  stateVersion,
  ...
}: {
  imports = [../common] ++ (lib.flocken.getModules ./.);

  custom.podman.enable = true;

  networking = {
    useNetworkd = true;
    # this is overridden by NetworkManager on workstations
    useDHCP = lib.mkDefault true;
    # this is not compatible with networkd
    useHostResolvConf = false;
  };

  i18n.defaultLocale = "en_US.UTF-8";

  nix = {
    settings = {
      # https://github.com/NixOS/nix/issues/7273#issuecomment-1310213986
      auto-optimise-store = true;
    };
    gc.dates = "daily";
  };

  users = {
    mutableUsers = true;
    defaultUserShell = pkgs.fish;
  };

  # Currently produces an error on darwin
  # https://github.com/LnL7/nix-darwin/issues/359
  time.timeZone = "Europe/Berlin";

  programs = {
    git = {
      enable = true;
    };
    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };
  };

  environment.defaultPackages = with pkgs; [
    rsync
    python3Minimal
    strace
  ];

  system = {
    inherit stateVersion;
  };

  security.sudo = {
    execWheelOnly = true;
  };

  security.sudo-rs = {
    enable = true;
    inherit
      (config.security.sudo)
      execWheelOnly
      wheelNeedsPassword
      ;
  };

  boot.loader = {
    systemd-boot.configurationLimit = 7;
    generic-extlinux-compatible.configurationLimit = 7;
    grub.configurationLimit = 7;
    raspberryPi.uboot.configurationLimit = 7;
  };
}
