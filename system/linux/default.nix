{
  config,
  lib',
  pkgs,
  stateVersion,
  ...
}:
{
  imports = [ ../common ] ++ (lib'.flocken.getModules ./.);

  custom.podman.enable = true;

  i18n.defaultLocale = "en_US.UTF-8";

  nix = {
    channel.enable = false;
    settings = {
      # https://github.com/NixOS/nix/issues/7273#issuecomment-1310213986
      auto-optimise-store = true;
      allowed-users = [ "@wheel" ];
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
    _1password.enable = true;
  };

  environment.defaultPackages = with pkgs; [
    rsync
    python3
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
    inherit (config.security.sudo) execWheelOnly wheelNeedsPassword;
  };

  boot.loader = {
    systemd-boot.configurationLimit = 7;
    generic-extlinux-compatible.configurationLimit = 7;
    grub.configurationLimit = 7;
    raspberryPi.uboot.configurationLimit = 7;
  };

  zramSwap = {
    enable = true;
    memoryPercent = 100;
    memoryMax = 8 * 1024 * 1024 * 1024;
  };
}
